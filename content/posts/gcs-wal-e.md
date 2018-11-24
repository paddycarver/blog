+++
date = "2015-09-22"
summary = "My efforts and progress on getting WAL-E to support Google Cloud Storage, and the stumbling blocks I’m facing."
title = "Google Cloud Storage & WAL-E (Part One)"
url = "/posts/gcs-wal-e"
+++


I’ve been trying to get [Google Cloud Storage](https://cloud.google.com/storage) support for [WAL-E](https://github.com/wal-e/wal-e) for [years](https://github.com/wal-e/wal-e/issues/122). Since July 2014, if we’re going to be precise about it. It is proving to be a fun nut to crack.

(OK, in fairness, I haven’t actively been working on this and trying to solve the problem for like 14 months; it was more like a month of trying to solve the problem in stolen time chunks, then a year of not touching it, then another month of trying to solve the problem in stolen time chunks.)

For those not familiar, WAL-E is a continuous archiving solution for Postgres. Basically, it helps you keep near-realtime backups of your database. Which is generally a Rather Useful Thing. It was built originally to support Amazon’s S3 storage solution, but it has been expanded to support Microsoft’s Azure and OpenStack’s Swift.

Google Cloud Storage is a storage solution provided by Google, very similar to S3, but which works nicely when you’re already using Google Cloud for other parts of your application.

WAL-E has four main modes: pushing point-in-time backups (full backups), pulling point-in-time backups, pushing incremental backups (which layer on top of full backups), and pulling incremental backups. If properly configured, it can help automatically manage your database clusters for you, so new instances that are spun up automatically just restore from the latest backup.

## The Good News

The good news is that the WAL-E core team seem open to Google Cloud Storage being added as an option, as well as adding dependencies as necessary to make that reasonable for code maintenance.

The WAL-E codebase is also nicely organised, with common functionality _mostly_ separated from storage provider-specific functionality.

The Python code is clean, sort of documented (at least, better than a lot of the Python code lots of us have to deal with in private codebases), and seems reasonably dedicated to [clarity]({{< relref "posts/cleverness.md" >}}).

## The Bad News

What WAL-E does is actually more complex than it seems. Specifically, there’s a feature that allows backups to be [lzop](http://www.lzop.org/) compressed. When downloading a backup to restore from, WAL-E intelligently manages disk space by using [streaming download and decompression](https://github.com/wal-e/wal-e/blob/98b81d0080a772fe26f4bb0e70bed04f9ecdb490/wal_e/blobstore/s3/s3_util.py#L68-L69), to avoid needing to download the entire file before decompression can start.

Unfortunately, Google Cloud Storage’s [`google-api-client-python`](https://github.com/google/google-api-python-client) library doesn’t _have_ a streaming download option. So using it would mean abandoning that nice property of “doesn’t require you to store the full compressed backup _while_ decompressing it”.

Fortunately, the [`boto` library](https://github.com/boto/boto) (which, incidentally, is what WAL-E is already using!) supports streaming downloads, and has support for Google Cloud Storage.

Problem solved, right?

Well, not quite.

See, remember when I said that Google Cloud Storage works well when you’re already using Google Cloud for other stuff? What I was referencing, specifically, is that you can tell Google Cloud that any server in your project can upload to that project’s storage space using internal authentication, instead of storing credentials on the server. This is the same general principle as assigning IAM roles to your EC2 instances.

You can probably see where I’m going with this.

Yup, as far as I can tell, `boto` doesn’t know how to take advantage of this for Google Cloud Storage.

Well, that’s not _strictly_ true. `boto` knows how to take advantage of this (through a [plugin developed by Google](https://github.com/GoogleCloudPlatform/gcs-oauth2-boto-plugin)), but not in a way that WAL-E likes.

You see, when configuring WAL-E’s authentication mechanism for requests, WAL-E [expects](https://github.com/wal-e/wal-e/blob/98b81d0080a772fe26f4bb0e70bed04f9ecdb490/wal_e/blobstore/s3/s3_credentials.py) a [`boto.provider.Provider`](https://github.com/boto/boto/blob/cb8aeec987ddcd5fecd206e38777b9a15cb0bcab/boto/provider.py#L77) subclass, which is a class that dictates how `boto` authenticates requests, and where it pulls authentication information from. WAL-E has a very specific set of places it wants the authentication to come from, and it is not the default set by `boto`’s Google provider.

To exacerbate problems, the plugin provided by Google isn’t a provider, it’s an auth handler, which is _used_ by providers. And `boto` _has_ a Google provider, which I _assume_ the auth handler hooks into, but I can’t find any good docs or writeups on how this works or what happens. Providers seems to be a very under-documented part of the (rather large) `boto` library. But it feels non-obvious how you’re supposed to go about customising or overriding the behaviour of that provider.

And to make things even more fun, it’s unclear whether the Google provider for `boto` only works when you put Google Cloud Storage into [compatibility mode](https://cloud.google.com/storage/docs/migrating#migration-simple) which (as best I can understand) only allows you to work on one bucket in any given project. Which sounds… not ideal. It also just feels like a hack that is bound to become unsupported at some point; a marketing gimmick to boost adoption, instead of an engineering decision meant to be supported.

So that’s where I’m standing now: trying to decide between a library that doesn’t quite match the tool I’m plugging it into, which doesn’t support a nice-to-have feature; or a library that matches the tool I’m plugging it into, supports all the features, but requires me to dig deep and understand a pretty-undocumented-but-rather-important class in an a different library, feels hacky, and may be unsupported in the future.

If any of y’all reading this are `boto` experts or know something I don’t, hitting me up on [Twitter](https://twitter.com/paddycarver) or [email](mailto:paddy+wale@carvers.co) would be appreciated.

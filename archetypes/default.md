+++
summary = "A brief summary of this post."
url = "/posts/{{ .TranslationBaseName }}"
title = "{{ replace .TranslationBaseName "-" " " | title }}"
date = {{ .Date }}
has_tweet = false
draft = true

[quote]
attr = "Person who said it"
text = "“Thing they said.”"

[img]
attr = "Person who took the picture"
file = "file in static/img/posts to use as the picture"
link = "link to the picture if required by rightsholder"
title = "title of picture"
+++

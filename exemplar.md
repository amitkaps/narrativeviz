---
layout: default
---

# Exemplar

<div>
{% for post in site.posts %}
	{% if post.category contains 'exemplar' %}
		<a href="{{ post.url }}"> <h2> {{ post.title }} </h2> </a>
		{{ post.content | truncatewords: 50 | strip_html }}
	{% endif %}
{% endfor %}
</div>
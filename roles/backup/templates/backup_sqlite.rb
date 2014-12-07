{% extends "backup_layout.rb" %}

{% block command_line %}"sudo tar czf #{backup_file} -C {{ backup_database_path }} {{ backup_database_name }}"{% endblock %}

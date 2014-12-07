{% extends "backup_layout.rb" %}

{% block command_line %}
  "mkdir -p /tmp/mongo_dumps && \
   sudo mongodump -db {{ backup_database_name }} -o /tmp/mongo_dumps/ && \
   sudo tar czf #{backup_file} -C /tmp/mongo_dumps/ {{ backup_database_name }} && \
   sudo rm -rf /tmp/mongo_dumps/{{ backup_database_name }}"
{% endblock %}

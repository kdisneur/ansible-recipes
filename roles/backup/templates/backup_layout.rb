#!/usr/bin/env ruby

require 'aws-sdk'
require 'date'

access_key_id     = '{{ backup_access_key_id }}'
secret_access_key = '{{ backup_secret_access_key }}'
backup_name       = "#{Date.today.to_s}.tgz"
backup_folder     = '{{ backup_type }}_{{ app_name }}'
backup_file       = File.join('/', 'var', 'backups', backup_folder, backup_name)
s3_object_name    = '{{ app_name }}/{{ backup_type }}.tgz'

system({% block command_line %}{% endblock %})

AWS::S3.new(access_key_id: access_key_id, secret_access_key: secret_access_key).buckets['{{ backup_bucket }}'].objects[s3_object_name].write(file: backup_file)

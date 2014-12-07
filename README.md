# Ansible recipes

## Installation

```shell
cp hosts{.sample,}
# Customize to add your own hosts (cf. configuration)
cp roles/bootstrap/files/publick_key{.sample,}
# Copy your public SSH key in this file
```

## Configuration

1. [Bootstrap](#bootstrap)
2. [Proxy to s3](#use-a-server-as-an-s3-proxy)
3. [Drone CI](#continuous-integration-with-drone)
4. [Wakeup Heroku](#wakeup-heroku)

Every command installs nginx in front of your application. nginx is just used as an HTTP proxy for your application.
If you want to use nginx as an HTTPS proxy for your application, you just have to copy 2 files in `roles/nginx/files/`.
If the following files are present (`<name of your server in the host file>.crt` and `<name of your server in the host file>.key`),
an SSL configuration is deployed on nginx and so, every HTTP request will be redirected to HTTPS.

### Bootstrap

If your server is a new one, you should run your first command with `run_bootstrap=y`. This option will run the the
following tasks before your action.

1. Add an `app` user (added in the `sudoers` group)
2. Copy your public SSH key
3. Disallow root SSH access and password authentication

### Use a server as an S3 proxy

1. Store your files on S3
2. Add a host in your `hosts` file and add it in the `s3_proxies` group:

```
my.awesome.host.io ansible_ssh_host=my.awesome.host.io s3_bucket_name=my.awesome.host.io.s3-eu-west-1.amazonaws.com

[s3_proxies]
my.awesome.host.io
```

3. Run one of the following tasks:

```shell
# To run the task on all your `s3_proxies` servers:
ansible-playbook s3_proxy/provisionning.yml -i hosts

# To run the task only on one of your s3_proxies' server:
ansible-playbook s3_proxy/provisionning.yml -i hosts --limit my.awesome.host.io
```

This task installs nginx and copy an nginx configuration file:

* Proxy all your requests to your S3 buckets
* If you request a folder, it will add the `index.html` path automatically (without any redirections)
* If you request a `index.html` it will redirect to its parent folder.

### Continuous Integration with Drone

1. Install a backup script to S3
2. Install nginx
3. Install docker
4. Install [drone.io](https://github.com/drone/drone)

```shell
# To run the task on all your `Drone` servers:
ansible-playbook drone/provisionning.yml -i hosts

# To run the task only on one of your Drone's server:
ansible-playbook drone/provisionning.yml -i hosts --limit my.awesome.ci.io
```

#### Add a Drone image

Once Drone is installed, it could be great to add Drone images to run your tests. You can add one with the following
command:

```shell
# To run the task on all your `Drone` servers:
ansible-playbook drone/add-image.yml -i hosts
$  What's the name of the docker image?
$> bradrydzewski/ruby:2.0.0

# To run the task only on one of your Drone's server:
ansible-playbook drone/add-image.yml -i hosts --limit my.awesome.ci.io
$  What's the name of the docker image?
$> bradrydzewski/ruby:2.0.0
```

### Wakeup Heroku

1. Install mongodb
2. Install nginx
3. Install a backup script to S3
4. Install ruby on rails
5. Install unicorn

```shell
# To run the task on all your `Wakeup Heroku` servers:
ansible-playbook wakeup_heroku/provisionning.yml -i hosts

# To run the task only on one of your Wakeup Heroku's server:
ansible-playbook wakeup_heroku/provisionning.yml -i hosts --limit my.awesome.wakeup_heroku.io
```

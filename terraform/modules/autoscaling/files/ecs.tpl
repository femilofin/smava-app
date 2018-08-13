[Unit]
Description=ECS agent

[Service]
Environment=ECS_CLUSTER=${cluster_name}
Environment=ECS_LOGLEVEL=info
Environment=ECS_VERSION=latest

Restart=on-failure
RestartSec=30
RestartPreventExitStatus=5

SyslogIdentifier=ecs-agent

ExecStartPre=/bin/mkdir -p /var/log/ecs /var/ecs-data /etc/ecs
ExecStartPre=/usr/bin/touch /etc/ecs/ecs.config
ExecStartPre=/bin/sh -c "/usr/bin/echo ECS_AVAILABLE_LOGGING_DRIVERS=[\\\"json-file\\\",\\\"syslog\\\",\\\"fluentd\\\"] > /etc/ecs/ecs.config"
ExecStartPre=-/usr/bin/docker kill ecs-agent
ExecStartPre=-/usr/bin/docker rm ecs-agent
ExecStartPre=/usr/bin/docker pull amazon/amazon-ecs-agent:latest
ExecStart=/usr/bin/docker run --name ecs-agent --env-file=/etc/ecs/ecs.config --volume=/var/run/docker.sock:/var/run/docker.sock --volume=/var/log/ecs:/log --volume=/var/ecs-data:/data --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro --volume=/run/docker/execdriver/native:/var/lib/docker/execdriver/native:ro --publish=127.0.0.1:51678:51678 --env=ECS_LOGFILE=/log/ecs-agent.log --env=ECS_LOGLEVEL=info --env=ECS_DATADIR=/data --env=ECS_CLUSTER=${cluster_name} amazon/amazon-ecs-agent:latest

[Install]
WantedBy=multi-user.target

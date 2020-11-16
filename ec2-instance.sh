docker-machine create \
                --driver amazonec2 \
                --amazonec2-instance-type m5.xlarge \
                --amazonec2-ami ami-0d971d62e4d019dcc \
                --amazonec2-region eu-central-1 \
                --amazonec2-zone b \
                --amazonec2-ssh-user ubuntu \
                --amazonec2-root-size 100 \
                mo

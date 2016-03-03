# Testing

 - *rake* Run all tests.  Go get a cup of coffee.

 - *rake spec*   Run chefspec and rspec tests

 - *rake style*  Run foodcritic and rubocop

 - *rake integration* Run test-kitchen tests (vagrant and EC2)

 - *rake integration:vagrant* Run only vagrant integration tests

 - *rake integration:ec2* Run only EC2 integration tests

 - *rake cloud* Run style, spec, and EC2 integration tests

In order to run any kitchen tests successfully, you'll need to set the
HALO_AGENT_KEY environment variable.  Optionally, you may set the HALO_AGENT_VERSION
environment variable to pin the test to a specific agent version.  Otherwise, the newest
linux agent gets installed.

In order to run the ec2 tests successfully, you'll need to have the following
additional environment variables set:

    AWS_ACCESS_KEY_ID         # API key
    AWS_SECRET_ACCESS_KEY     # API secret
    KITCHEN_AWS_SSH_KEY_ID    # This is the key as named in your Amazon AWS account
    KITCHEN_AWS_REGION        # Tested against us-west-2
    KITCHEN_AWS_REGION_ZONE   # Availability zone in the declared region
    KITCHEN_EC2_INSTANCE_TYPE # Instance type, for example: "m3.medium"
    KITCHEN_EC2_PUBLIC_IP     # Assign public IP to EC2 instances (true/false)
    KITCHEN_EC2_INTERFACE     # Which interface to connect to:
                              # (dns|public|private)
    KITCHEN_EC2_USER_DATA     # OPTIONAL (and Linux-only) see: https://github.com/test-kitchen/kitchen-ec2#user_data
    KITCHEN_EC2_SECURITY_GROUP_IDS # (Ruby-ish) list of AWS security groups
    KITCHEN_AWS_SUBNET_ID     # The subnet in which to create your test hosts
    KITCHEN_AWS_KEY_FILE      # This is the path to your AWS SSH key file
    UBUNTU_12_USER            # Username for Ubuntu 12
    UBUNTU_14_USER            # Username for Ubuntu 14
    RHEL_72_USER              # Username for RHEL 7.2
    AMZN_LIN_2015_09_USER     # Username for Amazon Linux 2015.09
    UBUNTU_12_AMI_ID          # AMI ID for Ubuntu 12
    UBUNTU_14_AMI_ID          # AMI ID for Ubuntu 14
    RHEL_72_AMI_ID            # AMI ID for RHEL 7.2
    AMZN_LIN_2015_09_AMI_ID   # AMI ID for Amazon Linux 2015.09
    WIN_2012_R2_AMI_ID        # AMI ID for Windows Server 2012 R2
    WIN_2008_R2_AMI_ID        # You'll have to custom-build an AMI for 2008R2 with
                              # Powershell v4.0 loaded.  Otherwise, comment that
                              # section out in the .kitchen.ec2.yml file.

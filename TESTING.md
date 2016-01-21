# Testing

 - *rake* Run all tests.  Go get a cup of coffee.

 - *rake spec*   Run chefspec and rspec tests

 - *rake style*  Run foodcritic and rubocop

 - *rake integration* Run test-kitchen tests (defaults to vagrant)

The integration tests will, by default, be defined by the .kitchen.yml file.  
This file only references linux hosts.  If you would like to test against
Windows hosts, set the KITCHEN_YAML environment variable to .kitchen.ec2.yml.

In order to run any kitchen tests successfully, you'll need to set the
HALO_AGENT_KEY environment variable.

In order to run the ec2 tests successfully, you'll need to have the following
additional environment variables set:

  AWS_ACCESS_KEY_ID      # API key
  AWS_SECRET_ACCESS_KEY  # API secret
  KITCHEN_AWS_SSH_KEY_ID # This is the key as named in your Amazon AWS account
  KITCHEN_AWS_REGION     # Tested against us-west-2
  KITCHEN_AWS_SUBNET_ID  # The subnet in which to create your test hosts
  KITCHEN_AWS_KEY_FILE   # This is the path to your AWS SSH key file
  AWS_AMI_2008R2         # You'll have to custom-build an AMI for 2008R2 with
                         # Powershell v4.0 loaded.  Otherwise, comment that
                         # section out in the .kitchen.ec2.yml file.

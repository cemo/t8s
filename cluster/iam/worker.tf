resource "aws_iam_role" "worker" {
  name = "t8s-worker-${ var.name }"

  assume_role_policy = <<EOS
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOS
}

resource "aws_iam_instance_profile" "worker" {
  name = "t8s-worker-${ var.name }"

  role = "${ aws_iam_role.worker.name }"
}

resource "aws_iam_role_policy" "worker" {
  name = "t8s-worker-${var.name}"
  role = "${ aws_iam_role.worker.id }"

  policy = <<EOS
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [ "${ var.s3-bucket-arn }/*" ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "ec2:AttachVolume",
        "ec2:DetachVolume",
        "ec2:DescribeInstances"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:BatchGetImage"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup"
      ],
      "Resource": "*"
    }
  ]
}
EOS
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "aws_iam_role.worker",
    "aws_iam_role_policy.worker",
    "aws_iam_instance_profile.worker",
  ]
}

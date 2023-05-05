// IAM group for EC2s, SSM and Secrets

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid    = "ec2sts"
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "assume_role" {
  name               = "ec2assumerole"
  description        = "Allow sts:AssumeRole for ec2 instances"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

// IAM instance profile
resource "aws_iam_instance_profile" "cloud1profile" {
  name = "cloud1profile"
  role = aws_iam_role.assume_role.name
}

// Policy attachement for our EC2 instances
resource "aws_iam_policy_attachment" "cloud1attach" {
  name       = "cloud1attachment"
  roles      = [aws_iam_role.assume_role.name]
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

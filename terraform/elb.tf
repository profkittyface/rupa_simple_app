resource "aws_lb" "rupa_lb" {
  name               = "rupa-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.rupa_simple_app_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.public2.id]

  tags = {
    Name = "rupa-lb"
  }
}

resource "aws_lb_target_group" "rupa_lb_tg" {
  name        = "rupa-lb-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.rupa_vpc.id
}

resource "aws_lb_listener" "rupa_lb_listener" {
  load_balancer_arn = aws_lb.rupa_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rupa_lb_tg.arn
  }
}

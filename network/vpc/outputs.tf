output "vpc_arn" {
  value = aws_vpc.main_vpc.arn
}
output "vpc_id" {
  value = aws_vpc.main_vpc.id
}
output "igw_id" {
  value = aws_internet_gateway.main_igw.id

}
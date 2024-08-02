# apkas-infra

個人で使うクラウドリソースの管理用Terraform。Macのローカルで動かす前提です

## setup

事前にローカルの `~/.aws/credential` に、以下のプロファイル名でAWSアクセス情報を保存してください。

```
[apkas-terraform-dev]
aws_access_key_id=xxx
aws_secret_access_key=yyy
```

## run

Dockerコンテナに入ってTerraformを実行します。

```sh
docker compose run --rm terraform
terraform init
terraform plan
terraform apply
```

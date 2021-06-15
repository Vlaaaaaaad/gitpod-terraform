# Gitpod Terraform image

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io#https://github.com/Vlaaaaaaad/gitpod-terraform)

Helper image for Terraform module development in [Gitpod](https://gitpod.io).

Tags available:

- `latest` which is the recommended tag ([Gitpod-official images use `latest` too](https://hub.docker.com/r/gitpod/workspace-full/tags))
- the date of the buld, like `2021-06-25` for tighter control of versions

To use the image, [set it in `.gitpod.yml`](https://www.gitpod.io/docs/42_config_docker/):

```yaml
image: public.ecr.aws/vlaaaaaaad/gitpod-terraform:latest
```

## Builtins

The image comes with several helpful tools pre-installed:

- `bash` which is also configured
- latest version of [Terraform](https://www.terraform.io/) installed by [`tfenv`](https://github.com/tfutils/tfenv) for a better user experience
- `cdktf` for people on the edge using [CDK (Cloud Development Kit) for Terraform](https://github.com/hashicorp/terraform-cdk)
- [pre-commit](https://pre-commit.com) for pre-commit hooks like [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs) for Terraform documentation generation
- [tflint](https://github.com/wata727/tflint) for Terraform best practices verification
- [tfsec](https://github.com/liamg/tfsec) for security best practices
- [conftest](https://github.com/instrumenta/conftest) for running Open Policy Agent tests on Terraform code

---

## Contributing

1. Fork it ([https://github.com/vlaaaaaaad/gitpod-terraform/fork](https://github.com/vlaaaaaaad/gitpod-terraform/fork))
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

## Credits

- [@jankeromnes](https://github.com/jankeromnes) for being [very helpful on a GitHub issue and providing guidance](https://github.com/gitpod-io/gitpod/issues/782)

## License

This project is provided under the [MIT License](https://github.com/vlaaaaaaad/gitpod-terraform/blob/master/LICENSE.md). See [LICENSE](https://github.com/vlaaaaaaad/gitpod-terraform/blob/master/LICENSE.md) for more information.

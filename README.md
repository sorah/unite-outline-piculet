# unite-outline-piculet

[unite-outline](https://github.com/Shougo/unite-outline) outline definition for [piculet](https://github.com/winebarrel/piculet); AWS EC2 security group DSL.

![](http://img.sorah.jp/2014-10-22_04-18-16_hvv1y.png)

## Depends on

- https://github.com/Shougo/unite-outline

## Usage

```
:setf ruby.piculet
:Unite outline
```

defining `autocmd` or using modeline to set filetype to `ruby.piculet` is strongly recommended.

## Example piculet file in the above screenshot

```
# vim: ft=ruby.piculet

ec2 do
  security_group "default" do
    description "default group for EC2 Classic"
  end
end

ec2 "vpc-XXXXXXXX" do
  security_group "default" do
    description "default VPC security group"

    ingress do
      permission :tcp, 22..22 do
        ip_ranges(
          "0.0.0.0/0",
        )
      end
      permission :any do
        groups(
          "any_other_group",
          "default"
        )
      end
    end

    egress do
      permission :any do
        ip_ranges(
          "0.0.0.0/0"
        )
      end
    end
  end

  security_group "foo" do
  end

  security_group "bar" do
    description "this is description"

    egress do
      permission :any do
        ip_ranges(
          "0.0.0.0/0"
        )
      end
    end
  end
end
```


## License

```
Copyright (c) 2014 Shota Fukumori (sora_h)

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

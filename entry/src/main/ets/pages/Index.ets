@Entry
@Component
struct Index {
  @State message: string = '欢迎登录';
//测试连接03
  build() {
    RelativeContainer() {
      Text(this.message)
        .id('TitleText')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .margin({
          top:'10%',
          left:'5%'
        })
        .alignRules({
          top:{anchor:'__container__',align: VerticalAlign.Top},
          left:{anchor:'__container__',align: HorizontalAlign.Start}
        })
      TextInput({
        placeholder:'账号'
      })
        .id('Account')
        .alignRules({
          top:{anchor:'TitleText',align:VerticalAlign.Bottom},
        })
        .margin({
          left:'10%',
          right:'10%',
          top:'10%'
        })
        .borderRadius(10)
        .border({
          color:Color.Gray,
          width:2
        })
      TextInput({
        placeholder:'密码'
      })
        .type(InputType.Password)
        .id('Password')
        .alignRules({
          top:{anchor:'Account',align:VerticalAlign.Bottom},
        })
        .margin({
          left:'10%',
          right:'10%',
          top:'10%'
        })
        .borderRadius(10)
        .border({
          color:Color.Gray,
          width:2
        })
      Button()
        .id('Comfirm')
        .backgroundColor('#00bbff')
        .borderRadius(37.5)
        .alignRules({
          top:{anchor:'Password', align: VerticalAlign.Bottom},
          right:{anchor:'__container__', align: HorizontalAlign.End}
        })
        .margin({
          top:'10%',
          right:'10%'
        })
        .width(75)
        .height(75)
    }
    .height('100%')
    .width('100%')
  }
}
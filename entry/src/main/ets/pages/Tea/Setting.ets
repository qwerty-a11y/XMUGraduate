import router from '@ohos.router'; // 导入路由模块

@Entry
@Component
struct  Setting {
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");
  @Prop image_phone: ResourceStr = $r("app.media.Settings_Contact");
  @Prop image_key: ResourceStr = $r("app.media.Settings_Password");
  @Prop image_feedback: ResourceStr = $r("app.media.Settings_Feedback");
  @Prop image_about: ResourceStr = $r("app.media.Settings_About");
  @Prop image_out: ResourceStr = $r("app.media.Settings_Logout");
  @Prop image_go: ResourceStr = $r("app.media.RightArrow");

  build() {
    Column(){
      Row() {
        // 图标固定居左，距离左侧边缘8像素
        Image(this.image_back)
          .width(24)
          .height(24)
          //.flexGrow(1)
          .margin({ left: 8 })// 图标左侧间距
          .onClick(() => {
            router.back()
          });

        // 文字在整个Row组件的中间位置
        Text('设置')
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .fontSize(14)

        Column(){}
        .width(24)
        .height(24)
        //.flexGrow(1)
        .margin({ right: 8 })
      }
      // 确保Row组件宽度充满父容器
      .width('100%')
      .height(65)
      .margin({ bottom: 15 })
      .backgroundColor('#ffff')
      .alignItems(VerticalAlign.Center);



      Text("您好，老师！")
        .fontSize(32)
        .width(300)
        .margin({bottom:15})

      //基础信息
      Column(){
        Column(){
          Text('基础信息')
            .fontSize(10)
            .width(300)
            .margin({bottom:5})
          Column(){
            Row(){
              Text('单位：**学院**系')
                .flexGrow(1)
                .fontSize(16)
                .margin({top:5,bottom:5,left:8})
            }
            //.margin({bottom:5})
            .width(320)
            .height(52)

            Row() {
              Divider()
                .width(230) // 可根据需要调整横线长度
                .color('#cccccc')
                .height(2)
            }
            .justifyContent(FlexAlign.End) // 使子组件（横线）靠右
            .width('80%') // Row宽度占满父容器
            //.margin({ bottom: 5 })

            Row(){
              Text('工号：**************')
                .flexGrow(1)
                .fontSize(16)
                .margin({top:5,bottom:5,left:8})
            }
            //.margin({bottom:5})
            .width(320)
            .height(52)

          }
          .width(320)
          .borderRadius(8)
          .backgroundColor('#ffff')
        }
      }
      .width(320)
      .margin({bottom:20})

      //功能
      Column(){
        Column(){
          Text('功能')
            .fontSize(10)
            .width(300)
            .margin({bottom:5})
          Column(){
            //修改联系方式
            Row(){
              Image(this.image_phone)
                .width(20)
                .height(20)
                .margin({left:12})

              Text('修改联系方式')
                .flexGrow(1)
                .fontSize(16)
                .margin({top:5,bottom:5,left:8})

              Image(this.image_go)
                .width(20)
                .height(20)
                .margin({right:12});

            }
            //.margin({bottom:5})
            .width(320)
            .height(52)
            .onClick(()=>{
              router.pushUrl({url: 'pages/Tea/ChangeContactInformation'});
            })

            Row() {
              Divider()
                .width(230) // 可根据需要调整横线长度
                .color('#cccccc')
                .height(2)
            }
            .justifyContent(FlexAlign.End) // 使子组件（横线）靠右
            .width('80%') // Row宽度占满父容器

            //修改密码
            Row(){
              Image(this.image_key)
                .width(20)
                .height(20)
                .margin({left:12})

              Text('修改密码')
                .flexGrow(1)
                .fontSize(16)
                .margin({top:5,bottom:5,left:8})

              Image(this.image_go)
                .width(20)
                .height(20)
                .margin({right:12});
            }
            //.margin({bottom:5})
            .width(320)
            .height(52)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Tea/ChangePassword' }); // 直接写目标页面路径
            })

            Row() {
              Divider()
                .width(230) // 可根据需要调整横线长度
                .color('#cccccc')
                .height(2)
            }
            .justifyContent(FlexAlign.End) // 使子组件（横线）靠右
            .width('80%') // Row宽度占满父容器

            //我要反馈
            Row(){
              Image(this.image_feedback)
                .width(20)
                .height(20)
                .margin({left:12})

              Text('我要反馈')
                .flexGrow(1)
                .fontSize(16)
                .margin({top:5,bottom:5,left:8})

              Image(this.image_go)
                .width(20)
                .height(20)
                .margin({right:12});
            }
            .margin({bottom:5})
            .width(320)
            .height(52)
          }
          .width(320)
          .backgroundColor('#ffff')
          .borderRadius(8)
          .margin({bottom:20})
          .onClick(() => {
            router.pushUrl({ url: 'pages/Tea/Feedback' }); // 直接写目标页面路径
          })

          //关于保研小助手
          Column(){
            Column(){
              Column(){
                Row(){
                  Image(this.image_about)
                    .width(20)
                    .height(20)
                    .margin({left:12})
                  Text('关于保研小助手')
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({top:5,bottom:5,left:8})
                }
                //.margin({bottom:5})
                .width(320)
                .height(52)

              }
              .width(320)
              .borderRadius(8)
              .backgroundColor('#ffff')
            }
          }
          .width(320)
          .margin({bottom:20})

          //退出登录
          Column(){
            Column(){
              Column(){
                Row(){
                  Image(this.image_out)
                    .width(20)
                    .height(20)
                    .margin({left:12})
                  Text('退出登录')
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({top:5,bottom:5,left:8})
                }
                //.margin({bottom:5})
                .width(320)
                .height(52)
                .borderRadius(8)
                .backgroundColor('#ffff')
                ;
              }
              .width(320)
            }
          }
          .width(320)
          .margin({bottom:20})
          .onClick(() => {
            router.pushUrl({ url: 'pages/Login' }); // 直接写目标页面路径
          })

        }
      }
      .width(320)

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f4fafa')
    .alignItems(HorizontalAlign.Center);
  }
}


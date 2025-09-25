import router from '@ohos.router'; // 导入路由模块

@Entry
@Component
struct  Setting {
  @Prop image_back: ResourceStr = $r('app.media.back');
  @Prop image_phone: ResourceStr = $r('app.media.Phone');
  @Prop image_key: ResourceStr = $r('app.media.Key');
  @Prop image_feedback: ResourceStr = $r('app.media.feedback');
  @Prop image_about: ResourceStr = $r('app.media.about');
  @Prop image_out: ResourceStr = $r('app.media.out');
  @Prop image_go: ResourceStr = $r('app.media.go');
  private ParentPage:number = 0;

  onPageShow(): void {
    const params = router.getParams() as Record<string, object>;
    if (params){
      this.ParentPage = Number(params['ParentPage']) || 0;
    }
  }

    build() {
        Column(){
          Row() {
            // 图标固定居左，距离左侧边缘8像素
            Image(this.image_back)
              .width(24)
              .height(24)
              .margin({ left: 8 })// 图标左侧间距
              .onClick(() => {
                router.pushUrl({ url: 'pages/main' ,params:{targetView:1,targetSubPage:this.ParentPage}}); // 直接写目标页面路径
              });

            // 文字在整个Row组件的中间位置
            Text('设置')
              .fontSize(14)
              // 关键：通过marginLeft自动填充图标右侧到中间的空间
              .position({x:'46%',y:27})
          }
          // 确保Row组件宽度充满父容器
          .width('100%')
          .height(65)
          .margin({bottom:15})
          .backgroundColor('#ffff')
          .alignItems(VerticalAlign.Center); // 垂直方向居中对齐

          Text("你好，同学！")
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
                      Text('单位：**学院**系**班')
                        .flexGrow(1)
                        .fontSize(16)
                        .margin({top:5,bottom:5,left:8})
                  }
                  .margin({bottom:5})
                  .width(320)
                  .backgroundColor('#ffff')

                  Row(){
                    Text('学号：**************')
                      .flexGrow(1)
                      .fontSize(16)
                      .margin({top:5,bottom:5,left:8})
                  }
                  .margin({bottom:5})
                  .width(320)
                  .backgroundColor('#ffff')

                }
                .width(320)
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
                    .margin({left:8})

                  Text('修改联系方式')
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({top:5,bottom:5,left:8})

                  Image(this.image_go)
                    .width(20)
                    .height(20)
                    .margin({right:8})
                }
                .margin({bottom:5})
                .width(320)
                .backgroundColor('#ffff')

                //修改密码
                Row(){
                  Image(this.image_key)
                    .width(20)
                    .height(20)
                    .margin({left:8})

                  Text('修改密码')
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({top:5,bottom:5,left:8})

                  Image(this.image_go)
                    .width(20)
                    .height(20)
                    .margin({right:8})
                }
                .margin({bottom:5})
                .width(320)
                .backgroundColor('#ffff')


                //我要反馈
                Row(){
                  Image(this.image_feedback)
                    .width(20)
                    .height(20)
                    .margin({left:8})

                  Text('我要反馈')
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({top:5,bottom:5,left:8})

                  Image(this.image_go)
                    .width(20)
                    .height(20)
                    .margin({right:8})
                }
                .margin({bottom:5})
                .width(320)
                .backgroundColor('#ffff')
              }
              .width(320)
              .margin({bottom:20})

              //关于保研小助手
              Column(){
                Column(){
                  Column(){
                    Row(){
                      Image(this.image_about)
                        .width(20)
                        .height(20)
                        .margin({left:8})
                      Text('关于保研小助手')
                        .flexGrow(1)
                        .fontSize(16)
                        .margin({top:5,bottom:5,left:8})
                    }
                    .margin({bottom:5})
                    .width(320)
                    .backgroundColor('#ffff')
                  }
                  .width(320)
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
                        .margin({left:8})
                      Text('退出登录')
                        .flexGrow(1)
                        .fontSize(16)
                        .margin({top:5,bottom:5,left:8})
                    }
                    .margin({bottom:5})
                    .width(320)
                    .backgroundColor('#ffff')
                    .onClick(() => {
                      router.pushUrl({ url: 'pages/login' }); // 直接写目标页面路径
                    });
                  }
                  .width(320)
                }
              }
              .width(320)
              .margin({bottom:20})


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


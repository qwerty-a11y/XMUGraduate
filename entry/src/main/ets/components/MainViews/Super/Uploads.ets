import router from '@ohos.router';
import { LengthMetrics } from '@kit.ArkUI'

@Component
export struct superUploadsView {
  @State StuOrTch: boolean = false //0=教师 1=学生
  @State StuMajor: boolean[] = [false, false, false, false, false]
  animateParams: AnimateParam[] = [
    {
      duration: 125,
      delay: 250,
      curve: Curve.EaseInOut
    },
    {
      duration: 125,
      curve: Curve.EaseInOut
    }
  ]
  customAnimate = TransitionEffect.asymmetric(
    TransitionEffect.translate({ y: '-20' }).combine(TransitionEffect.opacity(0)).animation({
      delay: 125,
      duration: 250,
      curve: Curve.EaseInOut
    }),
    TransitionEffect.translate({ y: '-20' }).combine(TransitionEffect.opacity(0)).animation({
      duration: 250,
      curve: Curve.EaseInOut
    }),
  )

  // 重置所有专业选择状态
  resetMajors() {
    this.StuMajor = [false, false, false, false, false]
  }

  build() {
    Column() {
      // 选择所有账号操作按钮
      Button('选择所有账号操作')
        .width('80%')
        .height(50)
        .backgroundColor('#84F2C3')
        .fontColor('#000000')
        .borderRadius(20)
        .margin({ top: 20, bottom: 20 })
        .shadow({
          radius: 4,
          color: '#ff5a5555',
          offsetX: 2,
          offsetY: 4
        });

      Column() {
        Column() {
          Text('自定义操作')
            .fontSize(18)
            .width('100%')

          Column() {
            // 顶部提示文本
            Text('请选择您要查询或批量操作的对象属性，可多选,不能同时选择教师和学生')
              .fontSize(18)
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({
                top: 20,
                bottom: 20,
                left: 20,
                right: 20
              });
          }
          .backgroundColor('#C5F4F3')
          .margin({ top: 10, bottom: 20 });
        }
        .width('100%')

        Column() {
          // 身份选择-教师
          Row() {
            Text('身份')
              .fontSize(18)
              .margin({ left: 30, top: 20, bottom: 20 })

            Row() {
              Text('教师')
                .backgroundColor(this.StuOrTch == false ? '#C5F4F3' : '#E5E5E5')
                .borderRadius(12)
                .fontSize(18)
                .padding({
                  left: 12,
                  right: 12,
                  bottom: 5,
                  top: 5
                })
                .onClick(() => {
                  // 切换教师选择状态
                  this.StuOrTch = false

                  // 选择教师时，自动取消学生和所有专业选择
                  this.resetMajors();
                });

              Text('学生')
                .fontSize(18)
                .padding({
                  left: 12,
                  right: 12,
                  bottom: 5,
                  top: 5
                })
                .backgroundColor(this.StuOrTch ? '#C5F4F3' : '#E5E5E5')
                .borderRadius(12)
                .onClick(() => {
                  // 切换学生选择状态
                  this.StuOrTch = true
                  this.StuMajor[4]=true
                });
            }.justifyContent(FlexAlign.SpaceAround).flexGrow(1).padding({ left: '10%', right: '10%' })
          }
          .width('100%')
          .backgroundColor('#ffffff')
          .borderRadius(20)
          .shadow({
            radius: 4,
            color: '#ff5a5555',
            offsetX: 2,
            offsetY: 4
          })
          .margin({ bottom: 20 });

          // 身份选择-学生及专业
          Column() {
            Column() {
              Text('专业')
                .fontSize(18)
                .margin({ left: 50, top: 20, bottom: 20 })
                .width('100%');

              Column() {
                Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.px(15), cross: LengthMetrics.px(15) } }) {
                  // 计科专业选择
                  Text('计科')
                    .fontSize(18)
                    .backgroundColor(this.StuMajor[0] ? '#C5F4F3' : '#E5E5E5')  // 选中时为蓝色  // 未选择学生时不可用
                    .borderRadius(12)
                    .padding({
                      left: 12,
                      right: 12,
                      bottom: 5,
                      top: 5
                    })
                    .margin({ left: 10, right: 10 })
                    .onClick(() => {
                      // 只有选择学生时才允许切换专业状态
                      if (this.StuOrTch) {
                        this.StuMajor = [false, false, false, false, false]
                        this.StuMajor[0] = true
                      }
                    });

                  // 软工专业选择
                  Text('软工')
                    .backgroundColor(this.StuMajor[1] ? '#C5F4F3' : '#E5E5E5')  // 未选择学生时不可用
                    .borderRadius(12)
                    .fontSize(18)
                    .padding({
                      left: 12,
                      right: 12,
                      bottom: 5,
                      top: 5
                    })
                    .margin({ left: 10, right: 10 })
                    .onClick(() => {
                      if (this.StuOrTch) {
                        this.StuMajor = [false, false, false, false, false]
                        this.StuMajor[1] = true
                      }
                    });

                  Text('智能')
                    .fontSize(18)
                    .padding({
                      left: 12,
                      right: 12,
                      bottom: 5,
                      top: 5
                    })
                    .backgroundColor(this.StuMajor[2] ? '#C5F4F3' : '#E5E5E5')  // 未选择学生时不可用
                    .borderRadius(12)
                    .margin({ left: 10, right: 10 })
                    .onClick(() => {
                      if (this.StuOrTch) {
                        this.StuMajor = [false, false, false, false, false]
                        this.StuMajor[2] = true
                      }
                    });

                  // 网安专业选择
                  Text('网安')
                    .margin({ left: 10, right: 10 })
                    .padding({
                      left: 12,
                      right: 12,
                      bottom: 5,
                      top: 5
                    })
                    .backgroundColor(this.StuMajor[3] ? '#C5F4F3' : '#E5E5E5')  // 未选择学生时不可用
                    .borderRadius(12)
                    .fontSize(18)
                    .onClick(() => {
                      if (this.StuOrTch) {
                        this.StuMajor = [false, false, false, false, false]
                        this.StuMajor[3] = true
                      }
                    });

                  // 网安专业选择
                  Text('全部')
                    .margin({ left: 10, right: 10 })
                    .padding({
                      left: 12,
                      right: 12,
                      bottom: 5,
                      top: 5
                    })
                    .backgroundColor(this.StuMajor[4] ? '#C5F4F3' : '#E5E5E5')  // 未选择学生时不可用
                    .borderRadius(12)
                    .fontSize(18)
                    .onClick(() => {
                      if (this.StuOrTch) {
                        this.StuMajor = [false, false, false, false, false]
                        this.StuMajor[4] = true
                      }
                    });
                }
                .width('100%')
                .padding({left:20,right:20,bottom:15})
              }
              .width('100%')

            }
            .width('100%')
            .shadow({
              radius: 4,
              color: '#ff5a5555',
              offsetX: 2,
              offsetY: 4
            })
            .margin({ bottom: 20 })
            .backgroundColor('#ffffff')
            .height(this.StuOrTch ? 'auto' : 0)
            .visibility(this.StuOrTch ? Visibility.Visible : Visibility.Hidden)
            .animation(this.animateParams[Number(this.StuOrTch)])
            .transition(this.customAnimate)
            .borderRadius(20);
          }
          .width('100%')

          // 确定按钮
          Button('确定')
            .width(120)
            .height(52)
            .fontColor('#000000')
            .backgroundColor('#84F2C3')
            .borderRadius(20)
            .onClick(() => {
              //console.log('选择的状态：', this.selectState);
              router.pushUrl({ url: 'pages/Super/Inform' });
            });
        }
        .width('85%')

      }
      .width('100%')
      .height('90%')
      .backgroundColor('#F5F5F5')
      .alignItems(HorizontalAlign.Center);
    }
  }
}
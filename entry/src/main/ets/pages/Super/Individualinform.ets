import router from '@ohos.router';
import { Account, Student } from '../../datatypes/Account';
import { StudentDetail, TeacherDetail } from '../../datatypes/AccountDetail';

interface OperationItem {
  name: string;
  isSelected: boolean;
}

@Entry
@Component
struct OperationPage {
  @Prop image_back: ResourceStr = $r('app.media.LeftArrow');
  @State account?:Account=undefined
  @State detail?:StudentDetail = undefined
  private typeList:string[] = ['学业竞赛','创新创业训练','科研成果','荣誉称号','社会工作','志愿服务','国际组织学习','参军入伍','体育比赛']

  aboutToAppear(): void {
    let params = router.getParams() as Record<string,object>
    this.account = params['account'] as Account
    this.detail = params['detail'] as StudentDetail
  }

  build() {
    Column() {
      // 头部区域
      Row() {
        Image(this.image_back)
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Super/Individual' ,params:this.account});
          });

        Text('个人信息')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .flexGrow(1)
          .textAlign(TextAlign.Center);

        Text('')
          .width(24)
          .height(24)
          .margin({ right: 16 });
      }
      .width('100%')
      .height(56)
      .backgroundColor('#ffffff');

      Scroll() {
        Column() {
          // 基础信息区域
          Column() {
            Column() {
              Text('基础信息')
                .fontSize(10)
                .width(300)
                .margin({ bottom: 5 })

              Column() {
                Row() {
                  Text('身份：')
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                  Text('学生')
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                }
                .width(320)
                .height(52)

                Row() {
                  Divider()
                    .width(230)
                    .color('#cccccc')
                    .height(2)
                }
                .justifyContent(FlexAlign.End)
                .width('80%')

                Row() {
                  Text('姓名：')
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                  Text(this.account!.Name)
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                }
                .width(320)
                .height(52)

                Row() {
                  Divider()
                    .width(230)
                    .color('#cccccc')
                    .height(2)
                }
                .justifyContent(FlexAlign.End)
                .width('80%')

                Row() {
                  Text('单位：')
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                  Text(this.detail?.department)
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                }
                .width(320)
                .height(52)

                Row() {
                  Divider()
                    .width(230)
                    .color('#cccccc')
                    .height(2)
                }
                .justifyContent(FlexAlign.End)
                .width('80%')

                Row() {
                  Text('账号：')
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                  Text(this.account!.ID)
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                }
                .width(320)
                .height(52)

                Row() {
                  Divider()
                    .width(230)
                    .color('#cccccc')
                    .height(2)
                }
                .justifyContent(FlexAlign.End)
                .width('80%')

                Row() {
                  Text('手机号：')
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                  Text(this.detail?.phone)
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                }
                .width(320)
                .height(52)

                Row() {
                  Divider()
                    .width(230)
                    .color('#cccccc')
                    .height(2)
                }
                .justifyContent(FlexAlign.End)
                .width('80%')

                Row() {
                  Text('邮箱：')
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                  Text(this.detail?.email)
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                }
                .width(320)
                .height(52)
              }
              .width(320)
              .borderRadius(8)
              .backgroundColor('#ffff')
            }
          }
          .width('90%')
          .margin({ top: 10, bottom: 20 })

          // 详细信息区域
          Column() {
            Column() {
              Text('详细信息')
                .fontSize(10)
                .width(300)
                .margin({ bottom: 5 })


              //-------------------学生------------------------
              Column() {
                Row() {
                  Text('专业排名：')
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                  Text(`${this.detail?.rank[0].toString()}/${this.detail?.rank[1].toString()}`)
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                }
                .width(320)
                .height(52)

                Row() {
                  Divider()
                    .width(230)
                    .color('#cccccc')
                    .height(2)
                }
                .justifyContent(FlexAlign.End)
                .width('80%')

                Row() {
                  Text('绩点：')
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                  Text(`${this.detail?.academy_score.toString()}/4.0`)
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                }
                .width(320)
                .height(52)

                Row() {
                  Divider()
                    .width(230)
                    .color('#cccccc')
                    .height(2)
                }
                .justifyContent(FlexAlign.End)
                .width('80%')

                Row() {
                  Text('综测：')
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                  Text(`${this.detail?.score.toString()}分`)
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                }
                .width(320)
                .height(52)

                Row() {
                  Divider()
                    .width(230)
                    .color('#cccccc')
                    .height(2)
                }
                .justifyContent(FlexAlign.End)
                .width('80%')

                Row() {
                  Text('四六级：')
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                  Text(`${this.detail?.cet4.toString()}/${this.detail?.cet6.toString()}`)
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                }
                .width(320)
                .height(52)

                Row() {
                  Divider()
                    .width(230)
                    .color('#cccccc')
                    .height(2)
                }
                .justifyContent(FlexAlign.End)
                .width('80%')

                // 循环渲染9个项目（移除泛型参数，保留item显式类型）
                ForEach(
                  this.typeList,
                  (item: string,index:number) => { // 显式标注item类型
                    Column() {
                      Row() {
                        Text(`${item}：`)
                          .fontSize(16)
                          .margin({ top: 5, bottom: 5, left: 8 })
                        Text(this.detail?.applications_score[index].toString())
                          .flexGrow(1)
                          .fontSize(16)
                          .margin({ top: 5, bottom: 5, left: 8 })
                      }
                      .width(320)
                      .height(52);

                      Row() {
                        Divider()
                          .width(230)
                          .color('#cccccc')
                          .height(2)
                      }
                      .justifyContent(FlexAlign.End)
                      .width('80%')
                    }
                  }
                )
              }
              .width(320)
              .borderRadius(8)
              .backgroundColor('#ffff')
              .margin({ bottom: 50 })

              //-----------------教师------------------
              Column() {
                Row() {
                  Text('已通过：')
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                  Text(`${this.detail?.applications_approved.toString()}份`)
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                }
                .width(320)
                .height(52)

                Row() {
                  Divider()
                    .width(230)
                    .color('#cccccc')
                    .height(2)
                }
                .justifyContent(FlexAlign.End)
                .width('80%')

                Row() {
                  Text('已驳回：')
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                  Text(`${this.detail?.applications_rejected.toString()}份`)
                    .flexGrow(1)
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                }
                .width(320)
                .height(52)


              }
              .width(320)
              .borderRadius(8)
              .backgroundColor('#ffff')
              .margin({ bottom: 50 })
            }
          }
          .width('90%')
          .margin({ top: 10, bottom: 20 })
        }
        .width('100%')
      }
      .width('100%')
      .flexGrow(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F8FA');
  }
}
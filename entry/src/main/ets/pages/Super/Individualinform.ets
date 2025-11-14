import router from '@ohos.router';

interface OperationItem {
  name: string;
  isSelected: boolean;
}

// 显式定义项目数据接口
interface ProjectItem {
  name: string;
  score: string;
}

@Entry
@Component
struct OperationPage {
  @Prop image_back: ResourceStr = $r('app.media.LeftArrow');
  // 显式标注数组类型，约束所有项符合ProjectItem结构
  private projectList: ProjectItem[] = [
    { name: '学业竞赛', score: '*分' },
    { name: '创新创业训练', score: '*分' },
    { name: '科研成果', score: '*分' },
    { name: '荣誉称号', score: '**/**' },
    { name: '社会工作', score: '*分' },
    { name: '志愿服务', score: '*分' },
    { name: '国际组织学习', score: '*分' },
    { name: '参军入伍', score: '*分' },
    { name: '体育比赛', score: '*分' }
  ];

  build() {
    Column() {
      // 头部区域
      Row() {
        Image(this.image_back)
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Super/Individual' });
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
                  Text('***')
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
                  Text('**学院**系**班')
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
                  Text('************')
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
                  Text('************')
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
                  Text('************')
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
                  Text('绩点：')
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5, left: 8 })
                  Text('*/4')
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
                  Text('**分')
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
                  Text('**/**')
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
                  this.projectList,
                  (item: ProjectItem) => { // 显式标注item类型
                    Column() {
                      Row() {
                        Text(`${item.name}：`)
                          .fontSize(16)
                          .margin({ top: 5, bottom: 5, left: 8 })
                        Text(item.score)
                          .flexGrow(1)
                          .fontSize(16)
                          .margin({ top: 5, bottom: 5, left: 8 })
                      }
                      .width(320)
                      .height(52)
                      .onClick(() => {
                        router.pushUrl({ url: 'pages/Super/Projects' });
                      });

                      Row() {
                        Divider()
                          .width(230)
                          .color('#cccccc')
                          .height(2)
                      }
                      .justifyContent(FlexAlign.End)
                      .width('80%')
                    }
                  },
                  (item: ProjectItem): string => item.name // 显式标注返回类型
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
                  Text('**份')
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
                  Text('**份')
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
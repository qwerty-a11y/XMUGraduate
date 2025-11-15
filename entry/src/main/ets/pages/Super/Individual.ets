import router from '@ohos.router';
import { Account, Student, Teacher } from '../../datatypes/Account';
import { AccountList } from '../../service/Super/AccountList';

interface OperationItem {
  name: string;
  isSelected: boolean;
}

@Entry
@Component
struct OperationPage {
  @Prop image_back: ResourceStr = $r('app.media.LeftArrow');
  @State operationList: OperationItem[] = [
    { name: '重置2fa', isSelected: false},
    { name: '冻结账号', isSelected: false },
    { name: '删除账号', isSelected: false },
    { name: '导出数据', isSelected: false },
    { name: '数据导出权限', isSelected: false },
    { name: '重置密码为：123456', isSelected: false },
  ];
  @State account?:Account=undefined
  @State isStudent:boolean = true

  aboutToAppear(): void {
    this.isStudent = (AccountList.Type < 2)
    if (this.isStudent) this.account = router.getParams() as Student
    else this.account = router.getParams() as Teacher

    //GetDetail();


  }

  @Builder detail(){
    if (this.isStudent) {
      Column() {
        Column() {
          Text('基础信息')
            .fontSize(10)
            .width(300)
            .margin({ bottom: 5 })
          //------------------------为学生时-------------------------------
          Column() {
            Row() {
              Text('身份：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
              Text('学生')
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
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

            Row() {
              Text('姓名：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text(this.account!.Name)
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
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

            Row() {
              Text('单位：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text('**学院**系**班')
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
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

            Row() {
              Text('账号：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text(this.account!.ID)
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
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

            Row() {
              Text('手机号：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text('************')
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
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

            Row() {
              Text('邮箱：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text('************')
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
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
      .width('90%')
      .margin({ top: 10, bottom: 20 })

      Button() {
        Text('查看详细信息')
          .fontSize(16)
          .margin({ top: 10, bottom: 10 })
      }
      .backgroundColor('#77F0EC')
      .width('90%')
      .margin({ top: 10, bottom: 10 })
      .onClick(() => {
        router.pushUrl({ url: 'pages/Super/Individualinform' , params:this.account}, router.RouterMode.Single);
      })
    } else {
      Column() {
        Column() {
          Text('基础信息')
            .fontSize(10)
            .width(300)
            .margin({ bottom: 5 })
          Column() {
            Row() {
              Text('身份：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
              Text('教师')
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
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

            Row() {
              Text('姓名：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text(this.account!.Name)
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
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

            Row() {
              Text('单位：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text('**学院**系')
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
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

            Row() {
              Text('账号：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text(this.account!.ID)
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
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

            Row() {
              Text('手机号：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text('************')
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
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

            Row() {
              Text('邮箱：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text('************')
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
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
      .width('90%')
      .margin({ top: 10, bottom: 20 })

      Button(){
        Text('查看详细信息')
          .fontSize(16)
          .margin({top:10,bottom:10})
      }
      .backgroundColor('#77F0EC')
      .width('90%')
      .margin({top:10,bottom:10})
      .onClick(() => {
        router.pushUrl({ url: 'pages/Super/Teacheck' }, router.RouterMode.Single);
      })
    }
  }

  build() {
    Column() {
      // 头部区域
      Row() {
        Image(this.image_back) // 假设存在返回图标资源
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Super/Inform' });
          });

        Text('个人信息与操作')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .flexGrow(1)
          .textAlign(TextAlign.Center);
        Text('') // 占位，保持标题居中
          .width(24)
          .height(24)
          .margin({ right: 16 });
      }
      .width('100%')
      .height(56)
      .backgroundColor('#ffffff');

      Scroll() {
        Column() {
          this.detail()
          // 操作列表区域
          Column() {
            Text('基础操作')
              .width('90%')
              .fontSize(10)
              .margin({bottom:-6})
            List() {
              ForEach(this.operationList, (item: OperationItem) => {
                ListItem() {
                  Row() {
                    Text(item.name)
                      .fontSize(16)
                      .margin({ left: 16 });
                    Toggle({ type: ToggleType.Switch, isOn: item.isSelected })
                      .margin({ right: 16 })
                      .onChange((isOn: boolean) => {
                        // 这里可以添加 Toggle 状态变化的逻辑，比如更新数据等
                        // 示例中仅演示 UI，暂不做复杂逻辑
                      });
                  }
                  .width('100%')
                  .height(48)
                  .justifyContent(FlexAlign.SpaceBetween)
                }
              });
            }
            .width('100%')
            .backgroundColor('#ffffff')
            .borderRadius(12)
            .margin({
              left: 16,
              right: 16,
              top: 16,
              bottom: 24
            });
          }
          .width('100%')
          .flexGrow(1);

          // 确定按钮区域
          Button('确定操作')
            .width(320)
            .height(40)
            .fontColor('#000000')
            .backgroundColor('#77F0EC')
            .borderRadius(20)
            .margin({ bottom: 60 })
            .onClick(() => {
              // 确定按钮点击逻辑，比如获取选中的操作项并执行对应操作
              const selectedItems = this.operationList.filter(item => item.isSelected);
              console.info('选中的操作项：', selectedItems);
              // 这里可以添加后续操作逻辑，如调用接口等
            })
            .onClick(() => {
              router.pushUrl({ url: 'pages/Super/Inform' }, router.RouterMode.Single);
            });
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
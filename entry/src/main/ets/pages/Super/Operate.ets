import router from '@ohos.router';

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

        Text('操作')
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

      // 操作列表区域
      Column() {
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
        .margin({ left: 16, right: 16, top: 16, bottom: 24 });
      }
      .width('100%')
      .flexGrow(1);

      // 确定按钮区域
      Button('确定')
        .width(120)
        .height(40)
        .fontColor('#000000')
        .backgroundColor('#77F0EC')
        .borderRadius(20)
        .margin({ bottom: 40 })
        .onClick(() => {
          // 确定按钮点击逻辑，比如获取选中的操作项并执行对应操作
          const selectedItems = this.operationList.filter(item => item.isSelected);
          console.info('选中的操作项：', selectedItems);
          // 这里可以添加后续操作逻辑，如调用接口等
        })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Super/Main' },router.RouterMode.Single);
        });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F8FA');
  }
}
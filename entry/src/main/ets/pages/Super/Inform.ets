import router from '@ohos.router';

// 定义学生信息接口
interface StudentItem {
  no: string;
  name: string;
  info: string;
  score: string;
  selected: boolean; // 标记是否被选中
}

@Entry
@Component
export struct SuperInform {
  // 图标资源
  @Prop image_back: ResourceStr = $r('app.media.LeftArrow');
  @Prop image_check: ResourceStr = $r('app.media.check');

  // 学生数据 - 初始化为全部选中
  @State studentData: StudentItem[] = [
    { no: 'No.1', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.2', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.3', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.4', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.5', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.6', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.7', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.8', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.9', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.10', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.11', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.12', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.13', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.14', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.15', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.16', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.17', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.18', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
    { no: 'No.19', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分', selected: true },
  ];

  // 状态管理
  @State currentPage: number = 1;
  private totalPages: number = 6;
  @State batchOperationMode: boolean = false; // 批量操作模式开关
  @State allSelected: boolean = true; // 全选状态

  // 全选方法 - 强制所有项选中
  selectAll() {
    this.studentData.forEach((_, index) => {
      this.studentData[index].selected = true;
    });
    this.allSelected = true;
  }

  // 取消全选方法 - 强制所有项未选中
  deselectAll() {
    this.studentData.forEach((_, index) => {
      this.studentData[index].selected = false;
    });
    this.allSelected = false;
  }

  // 检查是否所有项都被选中
  checkAllSelected(): boolean {
    return this.studentData.every(item => item.selected);
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image(this.image_back)
          .width(24)
          .height(24)
          .margin({ left: 8 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Super/Main' },router.RouterMode.Single);
          });

        Text('信息与操作')
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .fontSize(14)
          .fontWeight(FontWeight.Medium);

        Column() {}
        .width(24)
        .height(24)
        .margin({ right: 8 });
      }
      .width('100%')
      .height('10%')
      .position({ top: 0 })
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Center)
      .shadow({ radius: 2, color: '#00000010' });

      Column() {
        // 批量操作与全选控制区
        Row() {
          Text('批量操作')
            .fontSize(14)
            .backgroundColor(this.batchOperationMode ? '#C5F4F3' : '#E5E5E5')
            .borderRadius(12)
            .padding({ left: 8, right: 8, bottom: 4, top: 4 })
            .margin({ right: 25, left: 5 })
            .onClick(() => {
              this.batchOperationMode = !this.batchOperationMode;
              // 进入批量操作模式时默认全选
              if (this.batchOperationMode) {
                this.selectAll();
              }
            });

          if (this.batchOperationMode) {
            Text('全选')
              .fontSize(14);

            Toggle({ type: ToggleType.Switch, isOn: this.allSelected })
              .margin({ left: 5 })
              .onChange((isOn: boolean) => {
                isOn ? this.selectAll() : this.deselectAll();
              });

            Image($r('app.media.check'))
              .width(24)
              .height(24)
              .margin({ left: 50, right: 8 })
              .onClick(() => {
                router.pushUrl({ url: 'pages/Super/Operate'});
              });
          }
        }
        .width(300)
        .margin({ top: 10, bottom: 10, left: 10 });

        // 学生列表
        List() {
          ForEach(this.studentData, (item: StudentItem, index: number) => {
            ListItem() {
              Row() {
                // 仅在批量操作模式下显示勾选框
                if (this.batchOperationMode) {
                  Toggle({
                    type: ToggleType.Checkbox,
                    isOn: item.selected  // 勾选状态与数据绑定
                  })
                    .margin({ right: 10 })
                    .onChange((isOn: boolean) => {
                      // 更新数据状态
                      this.studentData[index].selected = isOn;
                      // 同步更新全选开关状态
                      this.allSelected = this.checkAllSelected();
                    });
                }

                // 学号
                Text(item.no)
                  .fontSize(14)
                  .width(this.batchOperationMode ? '15%' : '18%')
                  .textAlign(TextAlign.Center);

                // 姓名
                Text(item.name)
                  .fontSize(14)
                  .width(this.batchOperationMode ? '20%' : '22%')
                  .textAlign(TextAlign.Center);

                // 信息
                Text(item.info)
                  .fontSize(14)
                  .width(this.batchOperationMode ? '35%' : '40%')
                  .textAlign(TextAlign.Center);

                // 分数
                Text(item.score)
                  .fontSize(14)
                  .width(this.batchOperationMode ? '20%' : '20%')
                  .textAlign(TextAlign.Center);
              }
              .width('100%')
              .backgroundColor('#ffffff')
              .padding({ left: 8, right: 8, bottom: 6, top: 6 })
              .margin({ top: 5, bottom: 5 })
              .borderRadius(8)
              .shadow({ radius: 1, color: '#00000008' });
            }
          });
        }
        .width('90%')
        .height('90%');
      }
      .height('90%')
      .width('100%')
      .position({ y: '10%' });
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#F5F5F5');
  }
}

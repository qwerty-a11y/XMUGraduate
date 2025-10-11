import router from '@ohos.router';

// 定义学生信息接口
interface StudentItem {
  no: string;
  name: string;
  info: string;
  score: string;
}

@Component
export struct  superUploadsView{
  // 模拟学生数据
  @State studentData: Array<StudentItem> = [
    { no: 'No.1', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.2', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.3', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.4', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.5', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.6', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.7', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.8', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.9', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.10', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.11', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.12', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.13', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.14', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.15', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.16', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.17', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.18', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' },
    { no: 'No.19', name: 'XXX', info: 'xxxxxxxxxxxxx', score: 'XX分' }

  ];
  // 当前页码
  @State currentPage: number = 1;
  // 总页数
  private totalPages: number = 6;

  build() {
    Column() {
      // 顶部身份与专业筛选
      Row() {
        Column() {
          Text('教师')
            .fontSize(14)
        }
          .backgroundColor('#E5E5E5')
          .borderRadius(12)
          .padding({ left: 8,right:8,bottom:4 ,top: 4 })
          .margin({ right: 10,left:5 });

        Text('学生：')
          .fontSize(14);
        Column() {
          Text('计科')
            .fontSize(14)
        }
        .backgroundColor('#AAFAFB')
        .borderRadius(12)
        .padding({ left: 8,right:8,bottom:4 ,top: 4 })
        .margin({ right: 5,left:5 });

        Column() {
          Text('软工')
            .fontSize(14)
        }
        .backgroundColor('#E5E5E5')
        .borderRadius(12)
        .padding({ left: 8,right:8,bottom:4 ,top: 4 })
        .margin({ right: 5,left:5 });
        Column() {
          Text('智能')
            .fontSize(14)
        }
        .backgroundColor('#E5E5E5')
        .borderRadius(12)
        .padding({ left: 8,right:8,bottom:4 ,top: 4 })
        .margin({ right: 5,left:5 });

        Column() {
          Text('网安')
            .fontSize(14)
        }
        .backgroundColor('#E5E5E5')
        .borderRadius(12)
        .padding({ left: 8,right:8,bottom:4 ,top: 4 })
        .margin({ right: 5,left:5 });
      }
      .margin({ top: 10, bottom: 10});

      // 批量操作与全选
      Row() {
        Text('批量操作')
          .fontSize(14)
          .backgroundColor('#E5E5E5')
          .borderRadius(12)
          .padding({ left: 8,right:8,bottom:4 ,top: 4 })
          .margin({ right: 25,left:5 });

        Text('全选')
          .fontSize(14);

        Toggle({ type: ToggleType.Switch, isOn: false })
          .margin({ left: 5 });
      }
      .width(300)
      .margin({ bottom: 10, left: 10 });

      // 学生列表
      List() {
        ForEach(this.studentData, (item:StudentItem) => {
          ListItem() {
            Row() {
              Text(item.no)
                .fontSize(14)
                .width('15%')
                .textAlign(TextAlign.Center);

              Text(item.name)
                .fontSize(14)
                .width('20%')
                .textAlign(TextAlign.Center);

              Text(item.info)
                .fontSize(14)
                .width('45%')
                .textAlign(TextAlign.Center);

              Text(item.score)
                .fontSize(14)
                .width('20%')
                .textAlign(TextAlign.Center);
            }
            .width('100%')
            .backgroundColor('#ffffff')
            .padding({ left: 8,right:8,bottom:4 ,top: 4 })
            .margin({ right: 5,left:5 ,top:5,bottom:5});
          }
        });
      }
      .width('90%')
      .height('85%');

      // // 分页控件
      // Row() {
      //   Button({ type: ButtonType.Circle }) {
      //     Text('<')
      //       .fontSize(16)
      //   }
      //   .width(30)
      //   .height(30)
      //   //.disabled(this.currentPage === 1);
      //
      //   Text(`${this.currentPage}/${this.totalPages}`)
      //     .fontSize(14)
      //   //.margin({ horizontal: 10 });
      //
      //   Button({ type: ButtonType.Circle }) {
      //     Text('>')
      //       .fontSize(16)
      //   }
      //   .width(30)
      //   .height(30)
      //   //.disabled(this.currentPage === this.totalPages);
      // }
      // .margin({ top: 10, bottom: 20 })
      // .justifyContent(FlexAlign.Center);

    }
    .width('100%')
    .height('90%')
    .position({bottom:'10%'})
    .backgroundColor('#F5F5F5');
  }
}
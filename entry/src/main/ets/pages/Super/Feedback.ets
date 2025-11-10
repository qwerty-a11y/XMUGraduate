import router from '@ohos.router';

interface CardItem {
  status: string;
  statusColor: string;
  //type: string;
  from: string;
  time: string;
}

@Entry
@Component
export struct SuperUploadsView {
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");
  @Prop image_arrange: ResourceStr = $r("app.media.Sort"); // 排序图标
  @Prop image_filter: ResourceStr = $r("app.media.Filter"); // 筛选图标
  @Prop image_search: ResourceStr = $r("app.media.Search");
  @State SearchText: string = '';
  @State cardData: Array<CardItem> = [
    {
      status: '未处理',
      statusColor: '#FF0000',
      //type: '反馈',
      from: '**同学',
      time: '2025-10-11 10:00'
    },
    {
      status: '未处理',
      statusColor: '#FF0000',
      //type: '账号问题',
      from: '**教师',
      time: '2025-10-11 09:30'
    },
    {
      status: '已处理',
      statusColor: '#00FF00',
      //type: '反馈',
      from: '**教师',
      time: '2025-10-10 16:20'
    },
    {
      status: '已处理',
      statusColor: '#00FF00',
     // type: '账号问题',
      from: '**同学',
      time: '2025-10-10 15:10'
    }
  ];

  @Builder
  CardComponent(item: CardItem) {
    Row() {
      Column() {
        Row() {
          Text(item.status)
            .fontSize(14)
            .margin({ right: 5 });
          // 状态圆点
          Circle()
            .width(8)
            .height(8)
            .fill(item.statusColor);
        }
        .margin({ bottom: 5 });

        Text(`来自：${item.from}`)
          .fontSize(16);
      }
      .width('50%')
      .margin({ bottom: 10 ,top:10 });

      Column() {
        // Text(item.type)
        //   .fontSize(16)
        //   .fontWeight(FontWeight.Bold)
        //   .margin({ bottom: 5 });
        Text(item.time)
          .fontSize(12)
          .fontColor('#999999');
      }
      .width('50%')
      .alignItems(HorizontalAlign.Center)
      .margin({ right: 10 });
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .shadow({
      radius: 4,
      color: '#DDDDDD',
      offsetX: 0,
      offsetY: 2
    })
    .width(340)
    //.padding(10)
    .justifyContent(FlexAlign.Center); // 卡片内容水平居中
  }

  build() {
    Column() {
      // 顶部搜索及设置区域
      Column() {
        Row() {
          Image(this.image_back)
            .width(24)
            .height(24)
            .margin({ left: 8 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/Super/Main'},router.RouterMode.Single); // 直接写目标页面路径
            });


          Text('反馈')
            .flexGrow(1)
            .textAlign(TextAlign.Center)
            .fontSize(18)
            .fontWeight(FontWeight.Medium);

          Column() {
          }
          .width(24)
          .height(24)
          .margin({ right: 8 });
        }
        .width('100%')
        .height(65)
        .backgroundColor('#ffffff')
        .alignItems(VerticalAlign.Center)
        .shadow({ radius: 2, color: '#00000010' });


        Row() {
          Row() {
            Image(this.image_search)
              .width(24)
              .height(24)
              .margin({ left: 12 })
            TextInput({
              placeholder: 'Search',
              text: this.SearchText
            })
              .fontSize(16)
              .height(32)
              .backgroundColor('white')
              .placeholderColor('#999999')
              .margin({ left: 8 })
              .layoutWeight(1)
          }
          .backgroundColor('white')
          .borderRadius(20)
          .height(52)
          .width(270)
          .shadow({
            radius: 4,
            color: '#10000000',
            offsetX: 0,
            offsetY: 2
          })
          .margin({ left: 15 });

          Image(this.image_filter)
            .width(24)
            .height(24)
            .margin({ left: 8, right: 5 })
          Image(this.image_arrange)
            .width(24)
            .height(24)
        }
        .width('100%')
        .backgroundColor('#fff4fafa')
        .margin({ top: 10, bottom: 10 })
        .shadow({ radius: 10, color: '#00000010' })

        //.alignItems(VerticalAlign.Center)
      }
      .width('100%')
      .height('20%')
      .position({
        x: 0,
        y: 0
      });

      Column() {
        List() {
          ForEach(this.cardData, (item: CardItem) => {
            ListItem() {
              this.CardComponent(item);
            }
            .margin({ bottom: 10 })
            .width(340)
          });
        }
        .width(340)
      }
      .width(340)
      .position({
        top: '20%'
      })
      .height('80%')
      .width('100%') // 让List宽度占满
      .layoutWeight(1); // 让List占满剩余高度
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#f4fafa');
  }
}
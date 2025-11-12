import router from '@ohos.router';
import {Request} from '../../datatypes/PasswordResetRequest'

interface CardItem {
  status: string;
  statusColor: string;
  from: string;
  time: string;
}

@Entry
@Component
export struct StudentAccountIssue {
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");
  @Prop image_arrange: ResourceStr = $r("app.media.Sort"); // 排序图标
  @Prop image_filter: ResourceStr = $r("app.media.Filter"); // 筛选图标
  @Prop image_search: ResourceStr = $r("app.media.Search");
  @State SearchText: string = '';
  public itemData?:CardItem;

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

  aboutToAppear(): void {
    let item = router.getParams() as CardItem
    this.itemData = item
  }

  build() {
    Column(){

    }
  }
}
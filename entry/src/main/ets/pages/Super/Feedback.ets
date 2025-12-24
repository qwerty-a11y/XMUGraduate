import router from '@ohos.router';
import { Request } from '../../datatypes/Feedback'
import { FeedBacks } from '../../service/Super/AccountList';
import { DateUtils } from '../../utils';
import { emitter } from '@kit.BasicServicesKit';

@Entry
@Component
export struct SuperUploadsView {
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");
  @Prop image_arrange: ResourceStr = $r("app.media.Sort"); // 排序图标
  @Prop image_filter: ResourceStr = $r("app.media.Filter"); // 筛选图标
  @Prop image_search: ResourceStr = $r("app.media.Search");
  @State SearchText: string = '';
  @State cardData: Request[] = FeedBacks.List

  async update(){
    await FeedBacks.Refresh()
    this.cardData=[...FeedBacks.List]
  }

  async aboutToAppear() {
    emitter.on('back',()=>{
      this.update()
    })
    await this.update()
  }

  @Builder
  CardComponent(item: Request) {
    Row() {
      Column() {
        Row() {
          Text(item.Status?'已处理':'未处理')
            .fontSize(14)
            .margin({ right: 5 });
          // 状态圆点
          Circle()
            .width(8)
            .height(8)
            .fill(item.Status?Color.Green:Color.Red);
        }
        .margin({ bottom: 5 });

        Text("来自："+item.Name+" "+(item.Identity?'老师':'学生'))
          .fontSize(16);
      }
      .width('50%')
      .margin({ bottom: 10 ,top:10 });

      Column() {
        // Text(item.type)
        //   .fontSize(16)
        //   .fontWeight(FontWeight.Bold)
        //   .margin({ bottom: 5 });
        Text(DateUtils.ToString(item.UploadTime))
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
    .justifyContent(FlexAlign.Center) // 卡片内容水平居中
    .onClick(()=>{
      router.pushUrl({url:'pages/Super/FeedbackDetail',params:item})
    })
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
              router.back()
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



        //.alignItems(VerticalAlign.Center)
      }
      .width('100%')
      .height('10%')
      .position({
        x: 0,
        y: 0
      });

      Column() {
        List() {
          ForEach(this.cardData, (item: Request) => {
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
        top: '10%'
      })
      .height('90%')
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
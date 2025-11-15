import { Poster } from '../Stu/HomeComponents/TypeCard';
import router from '@ohos.router';
import { RecordEntry } from '../../../datatypes/Record';
import { DateUtils } from '../../../utils';
import { TestData } from '../../../debug/TestData';


@Component
export struct teaHomeView {
  @State homeNavBgColor: string = '#ffffffff';
  @Prop image_inform: ResourceStr = $r("app.media.inform");
  @Prop image_world: ResourceStr = $r("app.media.world");
  @Prop image_set: ResourceStr = $r("app.media.Settings");
  @Prop image_search: ResourceStr = $r("app.media.Search");
  private typeList:string[] = ['学业竞赛','创新创业训练','科研成果','荣誉称号','社会工作','志愿服务','国际组织学习','参军入伍','体育比赛']

  // 列表数据，包含所有所需字段
  @State reviewList: RecordEntry[] = TestData.RecordList;

  // 列表项组件
  @Builder
  ReviewItemComponent(item: RecordEntry, index: number) {
    Column() {
      Row() {
        // 左侧主要信息区
        Column() {
          Text(`${item.Title}`)
            .fontSize(14)
            .fontColor('#000000')
            .margin({ right: 20 ,bottom:10});
          // 加分类别和提交时间
          Text(`类别：${this.typeList[item.Type.valueOf()]}`)
            .fontSize(14)
            .fontColor('#666666')
            .margin({ right: 20 });
          Text(`上传时间：${DateUtils.ToString(item.UploadTime)}`)
            .fontSize(14)
            .fontColor('#666666');
        }
        .flexGrow(1)
        .padding({ left: 15 })
        .alignItems(HorizontalAlign.Start);

        // 右侧状态和处理时间区

      }
      .width('100%')
      .height(80)
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
        router.pushUrl({ url: 'pages/Tea/Review' ,params:item});
      });

      // 底部分隔线（最后一项不加）
      if (index+1 != this.reviewList.length) {
        Divider()
          .width('90%')
          .height(0.5)
          .color('#EEEEEE');
      }
    }
    .width('100%')
  }

  build() {
    Column() {
      // 顶部区域（保持不变）
      Column() {
        Row() {
          Text('Hi~')
            .fontSize(30)
            .margin({ top: 10, bottom: 5 });

          Image(this.image_set)
            .width(24)
            .height(24)
            .margin({ left: 8, right: 5 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/Tea/Setting' });
            });
        }
        .width('90%')
        .height(60)
        .backgroundColor('#fff4fafa')
        .shadow({ radius: 10, color: '#00000010' })
        .justifyContent(FlexAlign.SpaceBetween)

        Poster()
          .width(343)
          .height(200)

        Row() {
          Text('保研条例参考')
            .fontSize(20)
            .margin({ left: 10, right: 10 })

          Image(this.image_world)
            .width(24)
            .margin({ left: 10, right: 10, top: 10, bottom: 10 })
        }
        .width('90%')
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor('#84F2C3')
        .borderRadius(20)
        .margin({ top: 10, bottom: 10 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Tea/Rules' });
        });

        Text('若有新的审核，请及时处理')
          .fontSize(14)
          .width('86%')
          .margin({ top: 10, bottom: 10 })
      }
      .width('100%')
      .backgroundColor('#F4FAFA')

      // 可滚动列表区域
      Scroll() {
        Column() {
          // 列表容器
          Column() {
            ForEach(this.reviewList, (item: RecordEntry, index: number) => {
              this.ReviewItemComponent(item, index)
                // .onClick(() => {
                //   // 点击列表项跳转到详情页
                //   router.pushUrl({ url: `pages/ReviewDetail?id=${item.id}` });
                // });
            })
          }
          .width('90%')
          .backgroundColor('#FFFFFF')
          .borderRadius(10)
          .shadow({
            radius: 4,
            color: '#00000010',
            offsetX: 0,
            offsetY: 2
          })
        }
        .width('100%')
      }
      .height('39%') // 设置滚动区域高度为屏幕的50%，可根据需要调整
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f4fafa');
  }
}
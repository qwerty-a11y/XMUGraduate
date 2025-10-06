import { Poster,FeatureCard, CardItem } from '../../components/MainViews/HomeComponents/TypeCard';
import router from '@ohos.router'; // 导入路由模块

@Component
@Preview
export struct HomeView {
  // 控制首页导航项背景色
  @State homeNavBgColor: string = '#ffffffff';
  // 为数组添加明确的CardItem类型注解
  @State academicCards: Array<CardItem> = [
    {
      icon: $r('app.media.icon_1'),
      title: '学业竞赛',
      score: 0,
      addIcon: $r('app.media.Plus')
    },
    {
      icon: $r('app.media.icon_2'),
      title: '创新创业训练',
      score: 0,
      addIcon: $r('app.media.Plus')
    },
    {
      icon: $r('app.media.icon_3'),
      title: '学术研究',
      score: 0,
      addIcon: $r('app.media.Plus')
    },
  ];
  // 综合表现卡片数据
  @State performanceCards: Array<CardItem> = [
    {
      icon: $r('app.media.icon_4'),
      title: '荣誉称号',
      score: 0,
      addIcon: $r('app.media.Plus')
    },
    {
      icon: $r('app.media.icon_5'),
      title: '社会工作',
      score: 0,
      addIcon: $r('app.media.Plus')
    },
    {
      icon: $r('app.media.icon_6'),
      title: '志愿服务',
      score: 0,
      addIcon: $r('app.media.Plus')
    },
    {
      icon: $r('app.media.icon_7'),
      title: '国际组织学习',
      score: 0,
      addIcon: $r('app.media.Plus')
    },
    {
      icon: $r('app.media.icon_8'),
      title: '参军入伍',
      score: 0,
      addIcon: $r('app.media.Plus')
    }
  ];

  build() {
    Column() {
      // 可滚动内容区域
      Scroll() {
        Column() {
          // 顶部“Hi~”文字
          Text('Hi~')
            .fontSize(32)
            .width(320)
            .margin({ top: 10, bottom: 5 });

          // 书本图片组件
          Poster()
            .width('100%')
            .height(192)
            .margin({ bottom: 10 });

          // GPA 等信息区域
          Column({space:5}) {
            Row() {
              Text('GPA')
                .fontSize(16);
              Text('3.8/4.0')
                .fontSize(20)
                .textAlign(TextAlign.End)
                .flexGrow(1);
            }
            .width('90%')
            .margin({ bottom: 5 });

            Row() {
              Text('综测')
                .fontSize(16);
              Text('80/100')
                .fontSize(20)
                .textAlign(TextAlign.End)
                .flexGrow(1);
            }
            .width('90%')
            .margin({ bottom: 5 });

            Row() {
              Text('预计综测')
                .fontSize(16);
              Text('80/100')
                .fontSize(20)
                .textAlign(TextAlign.End)
                .flexGrow(1);
            }
            .width('90%')
            .margin({ bottom: 10 });
          }
          .width('92%')
          .backgroundColor('#ffffff')
          .shadow({offsetX:10, offsetY:10, color:'#40000000',radius:10})
          .borderRadius(5)
          .padding({ top: 5, bottom: 5 });

          // 学业专长标题
          Text('学业专长')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 15, bottom: 10 })
            .width('100%')
            .padding({ left: 20 });

          // 学业专长横向滚动区域
          Scroll() {
            Row() {
              // 为ForEach的item添加明确的CardItem类型
              ForEach(this.academicCards, (item: CardItem) => {
                FeatureCard({ item: item });
              })
            }
            .width('auto')
            .padding({ bottom: 10 });
          }
          .width('92%')
          //.height(224)
          .scrollable(ScrollDirection.Horizontal);

          // 综合表现标题
          Text('综合表现')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 15, bottom: 10 })
            .width('100%')
            .padding({ left: 20 });

          // 综合表现横向滚动区域
          Scroll() {
            Row() {
              // 为ForEach的item添加明确的CardItem类型
              ForEach(this.performanceCards, (item: CardItem) => {
                FeatureCard({ item: item });
              })
            }
            .width('auto')
            .padding({ bottom: 10 })
            .backgroundImagePosition({ x: '0', y: 0 });
          }
          .width('92%')
          //.height(224)
          .scrollable(ScrollDirection.Horizontal);

        }
        .width('100%')
        .alignItems(HorizontalAlign.Center);
      }
      .scrollable(ScrollDirection.Vertical)
      .height('90%')
      .position({
        x: 0,
        y: 0,  // 定位到父容器底部
        bottom: 100   // 关键偏移量设置
      })
      .width('100%')
      .height('90%')
      .backgroundImageSize(ImageSize.Auto)
      .backgroundImagePosition(Alignment.Center);

    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#f4fafa')
    .backgroundImagePosition(Alignment.Center)
    .backgroundImageSize(ImageSize.Cover);
  }
}

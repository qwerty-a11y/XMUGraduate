import { Poster } from '../Stu/HomeComponents/TypeCard';
import router from '@ohos.router';

// 定义包含所需字段的列表项类型
interface ReviewItem {
  id: number;
  name: string;        // 姓名
  studentId: string;   // 学号
  submitTime: string;  // 提交时间
  category: string;    // 加分类别
  handleTime?: string; // 处理时间（可选，未处理时为空）
  status: string;      // 状态
  statusColor: string; // 状态颜色
}

@Component
export struct teaHomeView {
  @State homeNavBgColor: string = '#ffffffff';
  @Prop image_inform: ResourceStr = $r("app.media.inform");
  @Prop image_world: ResourceStr = $r("app.media.world");
  @Prop image_set: ResourceStr = $r("app.media.Settings");
  @Prop image_search: ResourceStr = $r("app.media.Search");

  // 列表数据，包含所有所需字段
  @State reviewList: ReviewItem[] = [
    {
      id: 1,
      name: '张三',
      studentId: '2022001001',
      submitTime: '2025-10-19 09:00',
      category: '学术论文',
      status: '待审核',
      statusColor: '#FF4D4F'
    },
    {
      id: 2,
      name: '李四',
      studentId: '2022002005',
      submitTime: '2025-10-18 14:30',
      category: '竞赛获奖',
      handleTime: '2025-10-18 16:45',
      status: '已通过',
      statusColor: '#52C41A'
    },
    {
      id: 3,
      name: '王五',
      studentId: '2022003128',
      submitTime: '2025-10-17 10:15',
      category: '社会实践',
      status: '待审核',
      statusColor: '#FF4D4F'
    },
    {
      id: 4,
      name: '赵六',
      studentId: '2022001076',
      submitTime: '2025-10-16 08:20',
      category: '学术论文',
      handleTime: '2025-10-16 11:30',
      status: '已驳回',
      statusColor: '#FAAD14'
    },
    {
      id: 5,
      name: '孙七',
      studentId: '2022004032',
      submitTime: '2025-10-15 15:40',
      category: '竞赛获奖',
      handleTime: '2025-10-15 17:20',
      status: '已通过',
      statusColor: '#52C41A'
    }
  ];

  // 列表项组件
  @Builder
  ReviewItemComponent(item: ReviewItem) {
    Column() {
      Row() {
        // 左侧主要信息区
        Column() {
          // 姓名和学号
          Row() {
            Text(`姓名：${item.name}`)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .margin({ right: 20 });
            Text(`学号：${item.studentId}`)
              .fontSize(14)
              .fontColor('#666666');
          }
          .margin({ bottom: 8 });

          // 加分类别和提交时间
          Row() {
            Text(`类别：${item.category}`)
              .fontSize(14)
              .fontColor('#666666')
              .margin({ right: 20 });
            Text(`提交：${item.submitTime}`)
              .fontSize(14)
              .fontColor('#666666');
          }
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
        router.pushUrl({ url: 'pages/Tea/Review' });
      });

      // 底部分隔线（最后一项不加）
      if (item.id !== this.reviewList.length) {
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

        Text('您有新的审核，请及时处理')
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
            ForEach(this.reviewList, (item: ReviewItem) => {
              this.ReviewItemComponent(item)
                // .onClick(() => {
                //   // 点击列表项跳转到详情页
                //   router.pushUrl({ url: `pages/ReviewDetail?id=${item.id}` });
                // });
            }, (item: ReviewItem) => item.id.toString())
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
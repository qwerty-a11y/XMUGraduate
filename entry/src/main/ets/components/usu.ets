// usu.ets
import router from '@ohos.router'; // 导入路由模块

// 海报组件
@Component
export struct Poster {
  @Prop imageResource: ResourceStr = $r('app.media.haibao');

  build() {
    Image(this.imageResource)
      .width('100%')
      .height('100%')
      .objectFit(ImageFit.Contain);
  }
}

// 导航栏组件
@Component
export struct NavigationBar {
  public onPageSwitch?:(type:number) => void = undefined;
  // 接收当前页面路径（如 "/pages/Home" 或 "/pages/Checked"）
  @Link currentPage: number;
  // 导航图标资源（可外部传入，默认用现有资源）
  @Prop homeIcon: ResourceStr = $r('app.media.table1');
  @Prop reviewIcon: ResourceStr = $r('app.media.table2');
  // 颜色配置：当前页面使用主题色，非当前页面白色
  private activeColor: string = '#ffaafafb'; // 当前页面背景色
  private inactiveColor: string = '#FFFFFF'; // 非当前页面背景色

  build() {
    Row() {
      // 1. 首页导航按钮
      Column() {
        // 首页图标容器
        Column() {
          Image(this.homeIcon)
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
        }
        .width(100)
        .height(50)
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        // 逻辑：当前页面是首页 → 主题色，否则白色
        .backgroundColor(this.currentPage === 0 ? this.activeColor : this.inactiveColor)
        // 点击跳转首页
        .onClick(() => {
          this.onPageSwitch && this.onPageSwitch(0)
        });

        // 首页文字
        Text('首页')
          .fontSize(14)
          .height(22)
          .margin({ top: 5 })
          .fontColor('#00000000');
      }
      .width('50%')
      .alignItems(HorizontalAlign.Center);

      // 2. 审核页导航按钮
      Column() {
        // 审核页图标容器
        Column() {
          Image(this.reviewIcon)
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
        }
        .width(100)
        .height(50)
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        // 逻辑：当前页面是审核页 → 主题色，否则白色
        .backgroundColor(this.currentPage === 1 ? this.activeColor : this.inactiveColor)
        // 点击跳转审核页
        .onClick(() => {
          this.onPageSwitch && this.onPageSwitch(1)
        });

        // 审核页文字
        Text('审核')
          .fontSize(14)
          .height(22)
          .margin({ top: 5 })
          .fontColor('#00000000');
      }
      .width('50%')
      .alignItems(HorizontalAlign.Center);
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .shadow({ radius: 10, color: '#00000010' })
    .padding({ top: 10 });
  }
}


// 卡片数据结构
export interface CardItem {
  icon: ResourceStr;
  title: string;
  score: number;
  addIcon: ResourceStr; // "+"图标资源
}

// 功能卡片组件
@Component
export struct FeatureCard {
  @Prop item: CardItem;

  build() {
    Column() {
      // 卡片图标
      Image(this.item.icon)
        .width(100)
        .height(100)
        .borderRadius(30)
        .margin({ top: 10, bottom: 10 })
        .objectFit(ImageFit.Contain);

      // 卡片标题
      Text(this.item.title)
        .fontSize(16)
        .width(120)
        .margin({ top: 5, bottom: 15 })
        .textAlign(TextAlign.Start);

      // 分数和添加按钮
      Row() {
        Text(`${this.item.score}分`)
          .fontSize(16)
          .flexGrow(1);

        Image(this.item.addIcon)
          .width(32)
          .height(32)
          .objectFit(ImageFit.Contain);
      }
      .width(120)
      .margin({ top: 5 })
      .justifyContent(FlexAlign.SpaceBetween);
    }
    .width(150)
    .height(224)
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .padding(10)
    .shadow({ radius: 5, color: '#00000014' })
    .margin({ right: 10 })
    .alignItems(HorizontalAlign.Center);
  }
}

//顶栏组件
@Component
export struct top{
  public onTypeSwitch?:(type:number) => void = undefined;
  @Link currentPage: number;
  @Prop image_setting: ResourceStr = $r('app.media.set');
  @Prop image_search: ResourceStr = $r('app.media.Search');
  private activeColor: string = '#ff77f0ec'; // 当前页面背景色
  private inactiveColor: string = '#FFFFFF'; // 非当前页面背景色

  build() {
    Column(){
      Row(){
        Row() {
          Column() {
            Text('已审核')
              .fontSize(14)
              .margin({ bottom: 4 })
              .backgroundImagePosition(Alignment.Center);

            Column()
              .width(40)
              .height(11)
              .borderRadius(20)
              .backgroundColor(this.currentPage === 0 ? this.activeColor : this.inactiveColor);
          }
          .width(85)
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.onTypeSwitch && this.onTypeSwitch(0);
          });

          Column() {
            Text('审核中')
              .fontSize(14)
              .margin({ bottom: 4 });

            Column()
              .width(40)
              .height(11)
              .borderRadius(20)
              .backgroundColor(this.currentPage === 1 ? this.activeColor : this.inactiveColor);
          }
          .width(85)
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.onTypeSwitch && this.onTypeSwitch(1);
          });

        }
        .backgroundColor('#FFFFFFFF')
        .margin({left:8})
        .borderRadius({topLeft:20,topRight:20})
        .shadow({
          radius: 8,
          color: '#90001007',
          offsetX: 4,
          offsetY: 4
        });

        Column()
          .flexGrow(1)

        Image(this.image_setting)
          .width(24)
          .height(24)
          .backgroundImagePosition(Alignment.End)
          .margin({right: 8})
          .onClick(() => {
            router.pushUrl({ url: 'pages/setting' ,params:{ParentPage:this.currentPage}}); // 直接写目标页面路径
          });


      }
      .width(343)
      .height(52)
      .margin({bottom:15,top:10});

      Row() {
        Image(this.image_search) // 搜索图标资源，需替换为实际资源
          .width(24)
          .height(24)
          .margin({ left: 12 })
          .objectFit(ImageFit.Contain)

        TextInput({ placeholder: 'Search', text: '' })
          .fontSize(16)
          .height(32)
          .backgroundColor('white')
          .placeholderColor('#999999')
          .margin({ left: 8 })
          .flexGrow(1)
      }
      .justifyContent(FlexAlign.Center)
      .backgroundColor('white')
      .borderRadius(20)
      .height(52)
      .width(343) // 控制搜索栏宽度
      .shadow({
        radius: 4,
        color: '#00000010',
        offsetX: 0,
        offsetY: 2
      })
      .margin({ bottom: 10 })

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff4fafa')
    .shadow({ radius: 10, color: '#00000010' });

    }
}


// 卡片数据结构
export interface ActivityCard {
  status: string; // 审核状态
  activityName: string; // 活动名称
  publishTime: string; // 发布时间
  score: string; // 加分情况
  submitTime: string; // 提交时间
}

// 类别数据结构
export interface Category {
  name: string; // 类别名称
  cards: ActivityCard[]; // 该类别下的卡片数组
}

// 类别组件
@Component
export struct CategoryComponent {
  @Prop category: Category;

  build() {
    Column() {
      // 类别标题
      Text(this.category.name)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 10, bottom: 5 })
        .width('100%')
        .textAlign(TextAlign.Start);

      // 循环渲染该类别下的每个卡片
      ForEach(this.category.cards, (card: ActivityCard) => {
        ActivityCardComponent({ card: card });
      });
    }
    .width('100%')
    .padding({ left: 10, right: 10 });
  }
}

// 活动卡片组件
@Component
export struct ActivityCardComponent {
  @Prop card: ActivityCard;

  build() {
    Column() {
      Row() {
        Text(this.card.status)
          .fontSize(14)
          .fontColor(this.card.status.includes('失败') ? '#FF0000' : '#000000') // 审核失败文字标红
          .flexGrow(1);
        Text(this.card.publishTime)
          .fontSize(12);
      }
      .width(330)
      .margin({ bottom: 5 ,top: 10 });

      Row() {
        Text(this.card.activityName)
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .flexGrow(1);
        Column() {
          Text(this.card.score)
            .fontSize(20);
          Text(this.card.submitTime)
            .fontSize(12);
        }
      }
      .width(330)
      .margin({ bottom: 10 });
    }
    .width(343)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .shadow({ radius: 4, color: '#00000010', offsetX: 0, offsetY: 2 })
    .margin({ bottom: 10 });
  }
}


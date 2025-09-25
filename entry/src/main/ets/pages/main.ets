import { Poster, NavigationBar, FeatureCard, CardItem } from '../components/usu';
import {HomeView} from '../components/MainViews/Home'
import {UploadsView} from '../components/MainViews/Uploads'
import router from '@ohos.router'; // 导入路由模块

@Entry
@Component
struct Main {

  private isFirstLoad:boolean = true
  animateParam:AnimateParam = {
    duration:250,
    curve:Curve.EaseInOut
  }
  leftAnimationsFirst = TransitionEffect.asymmetric(
    TransitionEffect.IDENTITY.animation(this.animateParam),
    TransitionEffect.translate({x:'-100%'}).animation(this.animateParam)
  )
  leftAnimations = TransitionEffect.asymmetric(
    TransitionEffect.translate({x:'-100%'}).animation(this.animateParam),
    TransitionEffect.translate({x:'-100%'}).animation(this.animateParam)
  )
  rightAnimations = TransitionEffect.asymmetric(
    TransitionEffect.translate({x:'100%'}).animation(this.animateParam),
    TransitionEffect.translate({x:'100%'}).animation(this.animateParam)
  )
  // 控制首页导航项背景色
  @State homeNavBgColor: string = '#ffffffff';

  @State ActiveView:number = 0;

  @State ActiveSubPage:number = 0;
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

  onPageShow(): void {
    const params = router.getParams() as Record<string, object>
    if (params){
      this.ActiveView = Number(params['targetView']) || 0;
      this.ActiveSubPage = Number(params['targetSubPage']) || 0;
    }
  }

  @Builder
  View(){
    if (this.ActiveView==0) {
      if (this.isFirstLoad==true) {
        HomeView().transition(this.leftAnimationsFirst)
      }else{
        HomeView().transition(this.leftAnimations)
      }
    }else if (this.ActiveView==1){
      UploadsView({SelectedType:this.ActiveSubPage}).transition(this.rightAnimations)
    }
  }

  build() {
    Column() {
      this.View()
     // NavigationBar()
      NavigationBar({onPageSwitch:((index)=>{
        this.ActiveView=index
        this.isFirstLoad=false
      }),currentPage:this.ActiveView})
        .width('100%')
        .height('10%')
        .backgroundColor('#ffffffff')
        .position({
          x: 0,
          y: '90%',  // 定位到父容器底部
          bottom: 0   // 关键偏移量设置
        })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#f4fafa')
    .backgroundImagePosition(Alignment.Center)
    .backgroundImageSize(ImageSize.Cover);
  }
}

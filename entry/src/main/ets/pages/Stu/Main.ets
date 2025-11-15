// 导入自定义组件（海报、导航栏、功能卡片、卡片数据结构）
import {NavigationBar} from '../../components/Navigator';
// 导入核心视图组件（首页视图、审核页视图）
import {HomeView} from '../../components/MainViews/Stu/Home'
import {UploadsView} from '../../components/MainViews/Stu/Uploads'
// 导入鸿蒙路由模块，用于页面跳转与参数传递
import router from '@ohos.router';

// 入口组件装饰器，标识当前组件为页面入口
@Entry
@Component
struct Main {
  // 状态：标记是否为首次加载（用于控制首次进入首页的动画）
  private isFirstLoad:boolean = true
  // 动画参数配置：时长250ms，缓动曲线为"缓入缓出"（视觉过渡更自然）
  animateParam:AnimateParam = {
    duration:250,
    curve:Curve.EaseInOut
  }

  // 首页首次加载动画：入场无偏移（IDENTITY），离场向左移出（-100%）
  leftAnimationsFirst = TransitionEffect.asymmetric(
    TransitionEffect.IDENTITY.animation(this.animateParam), // 入场动画
    TransitionEffect.translate({x:'-100%'}).animation(this.animateParam) // 离场动画
  )
  // 首页非首次加载动画：入场/离场均向左移出（避免重复入场动画）
  leftAnimations = TransitionEffect.asymmetric(
    TransitionEffect.translate({x:'-100%'}).animation(this.animateParam),
    TransitionEffect.translate({x:'-100%'}).animation(this.animateParam)
  )
  // 审核页动画：入场/离场均向右移出
  rightAnimationsFirst = TransitionEffect.asymmetric(
    TransitionEffect.IDENTITY.animation(this.animateParam),
    TransitionEffect.translate({x:'100%'}).animation(this.animateParam)
  )
  // 审核页动画：入场/离场均向右移出
  rightAnimations = TransitionEffect.asymmetric(
    TransitionEffect.translate({x:'100%'}).animation(this.animateParam),
    TransitionEffect.translate({x:'100%'}).animation(this.animateParam)
  )

  // 状态：首页导航项背景色（当前未使用，预留扩展）
  @State homeNavBgColor: string = '#ffffffff';

  // 核心状态：控制当前激活的视图（0=首页，1=审核页）
  @State ActiveView:number = 0;
  // 状态：审核页数据更新触发器（通过布尔值反转触发子组件重新渲染）
  @State UpdateTrigger:boolean = false;
  // 状态：控制审核页子页面（预留扩展，当前未使用）
  @State ActiveSubPage:number = 0;

  /**
   * 页面显示时触发的生命周期方法
   * 功能：接收其他页面跳转时传递的路由参数，更新当前激活的视图与子页面
   */
  aboutToAppear(): void {
    let page = router.getParams()?(router.getParams() as Record<string,number>)['page']:0
    this.ActiveView = page
  }

  /**
   * 自定义构建函数（@Builder）：根据ActiveView状态渲染对应的视图
   * 作用：封装视图切换逻辑，避免build方法冗余
   */
  @Builder
  View(){
    if (this.ActiveView === 0) { // 激活首页
      if (this.isFirstLoad) { // 首次加载：使用首次入场动画
        HomeView().transition(this.leftAnimationsFirst)
      } else { // 非首次加载：使用普通动画
        HomeView().transition(this.leftAnimations)
      }
    } else if (this.ActiveView === 1) { // 激活审核页
      // 传递UpdateTrigger状态（双向绑定），用于触发审核页数据更新
      if (this.isFirstLoad){
        UploadsView({ UpdateTrigger: this.UpdateTrigger }).transition(this.rightAnimationsFirst)
      }else {
        UploadsView({ UpdateTrigger: this.UpdateTrigger }).transition(this.rightAnimations)
      }
    }
  }

  /**
   * 组件构建核心方法：定义页面布局结构
   */
  build() {
    // 垂直布局容器（Column）：占满屏幕，背景为浅蓝灰色
    Column() {
      // 渲染当前激活的视图（首页/审核页）
      this.View()

      // 底部导航栏组件：接收页面切换回调与当前激活状态
      NavigationBar({
        // 页面切换回调：点击导航项时更新ActiveView，并标记为非首次加载
        onPageSwitch: ((index) => {
          this.ActiveView = index
          this.isFirstLoad = false
        }),
        // 双向绑定当前激活的页面（用于导航项高亮）
        currentPage: this.ActiveView
      })
        .width('100%') // 宽度占满屏幕
        .height('10%') // 高度占屏幕10%
        .backgroundColor('#ffffffff') // 白色背景
        .position({ // 绝对定位：固定在屏幕底部
          x: 0,
          y: '90%',  // 顶部距离屏幕顶部90%（即底部10%区域）
          bottom: 0   // 底部贴合父容器底部
        })
    }
    .width('100%') // 父容器宽度占满屏幕
    .height('100%') // 父容器高度占满屏幕
    .alignItems(HorizontalAlign.Center) // 子组件水平居中
    .backgroundColor('#f4fafa') // 页面背景色（浅蓝灰）
    .backgroundImagePosition(Alignment.Center) // 背景图居中（当前未设置背景图，预留）
    .backgroundImageSize(ImageSize.Cover); // 背景图覆盖模式（预留）
  }
}
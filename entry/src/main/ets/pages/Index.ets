import { AnimatorParams } from "@kit.MediaLibraryKit"
import {StuLoginView} from '../components/Login/StuLogin'
import {LoginType} from  '../components/Login/LoginType'


@Entry
@Component
struct Index {
  private isFirstLoad:boolean = true
  animateOutParam:AnimateParam = {
    duration:500,
    curve:Curve.EaseIn
  }
  animateInParam:AnimateParam={
    delay:250,
    duration:500,
    curve:Curve.EaseOut
  }
  mainAnimationsFirst = TransitionEffect.asymmetric(
    TransitionEffect.IDENTITY.animation(this.animateInParam),
    TransitionEffect.translate({x:'-100%'}).animation(this.animateOutParam)
  )
  mainAnimations = TransitionEffect.asymmetric(
    TransitionEffect.translate({x:'-100%'}).animation(this.animateInParam),
    TransitionEffect.translate({x:'-100%'}).animation(this.animateOutParam)
  )
  childAnimations = TransitionEffect.asymmetric(
    TransitionEffect.translate({x:'100%'}).animation(this.animateInParam),
    TransitionEffect.translate({x:'100%'}).animation(this.animateOutParam)
  )
  @State activeViewIndex:number = 0;

  TriggerAnimate(index:number):void{
    this.activeViewIndex=index
    this.isFirstLoad=false
  }

  @Builder
  LoginView(){
    if(this.activeViewIndex==0) {
      if (this.isFirstLoad){
        LoginType({onTypeSelected:((index)=>this.TriggerAnimate(index))}).transition(this.mainAnimationsFirst)
      } else {
        LoginType({onTypeSelected:((index)=>this.TriggerAnimate(index))}).transition(this.mainAnimations)
      }
    } else if (this.activeViewIndex==1) {
      StuLoginView({onBack:(()=>this.TriggerAnimate(0))}).transition(this.childAnimations)
    }
  }


  build() {
    RelativeContainer() {
      Image($r('app.media.Title_background'))
        .objectFit(ImageFit.Fill)
      Image($r('app.media.logo'))
        .id('TitleLogo')
        .width('70%')
        .objectFit(ImageFit.Contain)
        .margin({
          top:'15%',
          left:'15%',
          right:'15%'
        })
      Column(){
        this.LoginView()
      }
        .alignRules({
          top:{anchor:"TitleLogo",align:VerticalAlign.Bottom}
        })
        .margin({
          top:'5%'
        })


    }
    .height('100%')
    .width('100%')
  }
}
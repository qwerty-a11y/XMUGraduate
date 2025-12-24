import { Baoyanstartbg } from '../components/Baoyanstart';
import router from '@ohos.router'; // 导入路由模块
import { ROUTERstu, ROUTERsuper, ROUTERtea } from '../routerConstants'; // 导入路由常量
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';
import { StaticData, DynamicData } from '../constants';
import json from '@ohos.util.json';
import { BusinessError } from '@kit.BasicServicesKit';
import * as StuBasicData from '../service/Stu/BasicData'
import * as TeaBasicData from '../service/Tea/BasicData'
import { AccountList, FeedBacks } from '../service/Super/AccountList';

//import { InputType } from '@ohos.input';
//import { Curve } from '@ohos.animation';

// 定义动画参数类型
interface AnimateParam {
  duration: number;
  curve: Curve;
}

interface LoginRequest {
  user_type: string,
  school_id: string,
  password: string,
  code: string
}

interface empty {}

@Entry
@Component
struct login {
  @State selectedValue: string = 'student'; // 初始选择学生身份
  @State account: string = ''; // 账号状态
  @State password: string = ''; // 密码状态
  @State code: string = ''
  @State _2FAPage: boolean = false
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");
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
  rightAnimations = TransitionEffect.asymmetric(
    TransitionEffect.translate({x:'100%'}).animation(this.animateParam),
    TransitionEffect.translate({x:'100%'}).animation(this.animateParam)
  )

  async request() {
    //this._2FAPage=true
    //this.isFirstLoad=false
    if (this.account && this.password) {
      let httpRequest = http.createHttp();
      let RequestData: LoginRequest = {
        'user_type': this.selectedValue,
        'school_id': this.account,
        'password': this.password,
        'code': this.code
      }
      let RequestDataStr: string = json.stringify(RequestData)
      try {
        let Response: http.HttpResponse = await httpRequest.request(
          StaticData.ServerURL + '/api/auth/login/',
          {
            method: http.RequestMethod.POST,
            extraData: RequestDataStr,
            header: {
              'Content-Type': 'application/json', // 关键：添加这个头
              'Accept': 'application/json' // 可选：告诉服务器期望 JSON 响应
            },
            connectTimeout:5000
          }
        )
        let DataObj: Object | empty
        let DataObjTmp: object | null
        try {
          if (Response.responseCode == 200) {
            DataObjTmp = json.parse(Response.result.toString())
            DataObj = DataObjTmp ? DataObjTmp : {}
            let obj=DataObj as Record<string, string>
            DynamicData.account_id = this.account
            DynamicData.token = obj['token']
            DynamicData.phone = obj['contact']
            DynamicData.email = obj['email']
            if (this.selectedValue === 'student') {
              DynamicData.account_type = 0
              this.login()
            } else if (this.selectedValue === 'super') {
              DynamicData.account_type = 2
              if (this._2FAPage) router.pushUrl({url:'pages/Super/Main'})
              else router.pushUrl({url:'pages/Add2FA'})
            } else if (this.selectedValue === 'teacher') {
              DynamicData.account_type = 1
              if (this._2FAPage) router.pushUrl({url:'pages/Tea/Main'})
              else router.pushUrl({url:'pages/Add2FA'})
            }

          } else if (Response.responseCode == 401){
            if(!this._2FAPage) {
              this._2FAPage = true
              this.isFirstLoad = false
            } else {
              promptAction.showToast({
                message: '验证码错误，请重试',
                duration: 2000 // 弹窗显示时间（毫秒）
              });
            }
          } else {
            // 使用 promptAction 显示提示
            promptAction.showToast({
              message: '登录失败，请检查账号密码是否正确',
              duration: 2000 // 弹窗显示时间（毫秒）
            });
          }
        } catch (e) {
          let error = e as BusinessError
          let msg = error?.message
          // 使用 promptAction 显示提示
          promptAction.showToast({
            message: '解析错误：' + msg,
            duration: 2000 // 弹窗显示时间（毫秒）
          });
          return;
        }
      } catch (e) {
        let err: BusinessError = e as BusinessError
        console.log(err.message)
        console.log(err.name)
      }
    } else {
      // 使用 promptAction 显示提示
      promptAction.showToast({
        message: '请输入正确的账号和密码',
        duration: 2000 // 弹窗显示时间（毫秒）
      });
    }
  }

  // 登录方法：验证账号密码，跳转首页
  login() {
    if (this.selectedValue === 'student') {
      router.pushUrl({ url: ROUTERstu.HOME });
    } else if (this.selectedValue === 'super') {
      router.pushUrl({ url: ROUTERsuper.HOME });
    } else if (this.selectedValue === 'teacher') {
      router.pushUrl({ url: ROUTERtea.HOME });
    }
  }

  aboutToAppear(): void {
    router.clear()
    DynamicData.account_id=''
    DynamicData.token=''
    StuBasicData.BasicData.clear()
    TeaBasicData.BasicData.clear()
    AccountList.List=[]
    FeedBacks.List=[]
  }

  @Builder
  LoginAnd2FA(){
    if (this._2FAPage){
      RelativeContainer() {
        Column() {
          Text('需要2FA验证，请输入TOTP验证码').padding({ bottom: 15 })
          // 验证码输入框
          TextInput({ placeholder: '验证码' })
            .width('100%')
            .height(40)
            .backgroundColor('#FFFFFF')
            .borderRadius(8)
            .shadow({
              color: '#12000000',
              radius: 4,
              offsetX: 2,
              offsetY: 4
            })
            .type(InputType.Number)
            .margin({ bottom: 15 })
            .onChange((value: string) => this.code = value); // 输入时更新account

          // 登录按钮：点击触发login方法
          Button('确认')
            .width('80%')
            .height(45)
            .backgroundColor('#ff77f0ec')
            .borderRadius(16)
            .onClick(() => this.request()); // 点击登录
          //.onClick(() => this.login()); // 点击登录
        }
        .id('core')
        .width(257)
        .height(300)
        .margin({ bottom: 20 })
        .alignRules({middle:{anchor:'__container__',align:HorizontalAlign.Center}})
        Image(this.image_back)
          .width(24)
          .height(24)
          .alignRules({
            top:{anchor:'__container__',align:VerticalAlign.Top},
            right:{anchor:'core',align:HorizontalAlign.Start}
          })
          .onClick(() => {
            this._2FAPage=false
          });
      }
      .height(300)
      .transition(this.rightAnimations)
      .width('100%')
    } else {
      if (this.isFirstLoad) {
        Column() {
          // 身份选择 RelativeContainer（学生、教师、超管）
          RelativeContainer() {
            Column()
              .height(42)
              .borderRadius(20)
              .width('33.33%')
              .alignRules({
                middle: { anchor: this.selectedValue, align: HorizontalAlign.Center }
              })
              .backgroundColor('#AFEEEE')
              .animation(this.animateParam);

            Row() {
              Radio({ value: 'student', group: 'identity' })
                .checked(this.selectedValue === 'student')
                .onChange((isChecked: boolean) => {
                  if (isChecked) {
                    this.selectedValue = 'student';
                  }
                })
                .width(0)
                .height(0)
                .position({ x: -100, y: 0 });
              Text('学生')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .height(42)
                .backgroundColor(Color.Transparent)
                .borderRadius(20)
                .flexGrow(1)
                .textAlign(TextAlign.Center)
                .onClick(() => this.selectedValue = 'student');
            }
            .id('student')
            .width('33.33%')
            .flexGrow(1);

            Row() {
              Radio({ value: 'teacher', group: 'identity' })
                .checked(this.selectedValue === 'teacher')
                .onChange((isChecked: boolean) => {
                  if (isChecked) {
                    this.selectedValue = 'teacher';
                  }
                })
                .width(0)
                .height(0)
                .position({ x: -100, y: 0 });
              Text('教师')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .height(42)
                .backgroundColor(Color.Transparent)
                .borderRadius(20)
                .flexGrow(1)
                .textAlign(TextAlign.Center)
                .onClick(() => this.selectedValue = 'teacher');
            }
            .id('teacher')
            .width('33.34%')
            .alignRules({
              left: { anchor: 'student', align: HorizontalAlign.End }
            })
            .flexGrow(1);

            Row() {
              Radio({ value: 'super', group: 'identity' })
                .checked(this.selectedValue === 'super')
                .onChange((isChecked: boolean) => {
                  if (isChecked) {
                    this.selectedValue = 'super';
                  }
                })
                .width(0)
                .height(0)
                .position({ x: -100, y: 0 });
              Text('超管')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .height(42)
                .backgroundColor(Color.Transparent)
                .borderRadius(20)
                .flexGrow(1)
                .textAlign(TextAlign.Center)
                .onClick(() => this.selectedValue = 'super');
            }
            .id('super')
            .alignRules({
              left: { anchor: 'teacher', align: HorizontalAlign.End }
            })
            .width('33.33%')
            .flexGrow(1);
          }
          .width('100%')
          .height(42)
          .margin({ bottom: 15 })
          .borderRadius(20)
          .backgroundColor('#FFFFFF');

          // 账号输入框：绑定account状态
          TextInput({ placeholder: '输入账号' ,text:this.account})
            .width('100%')
            .height(40)
            .backgroundColor('#FFFFFF')
            .borderRadius(8)
            .shadow({
              color: '#12000000',
              radius: 4,
              offsetX: 2,
              offsetY: 4
            })
            .margin({ bottom: 15 })
            .onChange((value: string) => this.account = value); // 输入时更新account

          // 密码输入框：绑定password状态
          TextInput({ placeholder: '输入密码' ,text:this.password})
            .type(InputType.Password)
            .width('100%')
            .height(40)
            .backgroundColor('#FFFFFF')
            .borderRadius(8)
            .shadow({
              color: '#12000000',
              radius: 4,
              offsetX: 2,
              offsetY: 4
            })
            .margin({ bottom: 15 })
            .onChange((value: string) => this.password = value); // 输入时更新password

          // 登录按钮：点击触发login方法
          Button('登录')
            .width('80%')
            .height(45)
            .backgroundColor('#ff77f0ec')
            .borderRadius(16)
            .onClick(() => this.request()); // 点击登录
          //.onClick(() => this.login()); // 点击登录
        }
        .width(257)
        .height(300)
        .transition(this.leftAnimationsFirst)
        .margin({ bottom: 20 });
      } else {
        Column() {
          // 身份选择 RelativeContainer（学生、教师、超管）
          RelativeContainer() {
            Column()
              .height(42)
              .borderRadius(20)
              .width('33.33%')
              .alignRules({
                middle: { anchor: this.selectedValue, align: HorizontalAlign.Center }
              })
              .backgroundColor('#AFEEEE')
              .animation(this.animateParam);

            Row() {
              Radio({ value: 'student', group: 'identity' })
                .checked(this.selectedValue === 'student')
                .onChange((isChecked: boolean) => {
                  if (isChecked) {
                    this.selectedValue = 'student';
                  }
                })
                .width(0)
                .height(0)
                .position({ x: -100, y: 0 });
              Text('学生')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .height(42)
                .backgroundColor(Color.Transparent)
                .borderRadius(20)
                .flexGrow(1)
                .textAlign(TextAlign.Center)
                .onClick(() => this.selectedValue = 'student');
            }
            .id('student')
            .width('33.33%')
            .flexGrow(1);

            Row() {
              Radio({ value: 'teacher', group: 'identity' })
                .checked(this.selectedValue === 'teacher')
                .onChange((isChecked: boolean) => {
                  if (isChecked) {
                    this.selectedValue = 'teacher';
                  }
                })
                .width(0)
                .height(0)
                .position({ x: -100, y: 0 });
              Text('教师')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .height(42)
                .backgroundColor(Color.Transparent)
                .borderRadius(20)
                .flexGrow(1)
                .textAlign(TextAlign.Center)
                .onClick(() => this.selectedValue = 'teacher');
            }
            .id('teacher')
            .width('33.34%')
            .alignRules({
              left: { anchor: 'student', align: HorizontalAlign.End }
            })
            .flexGrow(1);

            Row() {
              Radio({ value: 'super', group: 'identity' })
                .checked(this.selectedValue === 'super')
                .onChange((isChecked: boolean) => {
                  if (isChecked) {
                    this.selectedValue = 'super';
                  }
                })
                .width(0)
                .height(0)
                .position({ x: -100, y: 0 });
              Text('超管')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .height(42)
                .backgroundColor(Color.Transparent)
                .borderRadius(20)
                .flexGrow(1)
                .textAlign(TextAlign.Center)
                .onClick(() => this.selectedValue = 'super');
            }
            .id('super')
            .alignRules({
              left: { anchor: 'teacher', align: HorizontalAlign.End }
            })
            .width('33.33%')
            .flexGrow(1);
          }
          .width('100%')
          .height(42)
          .margin({ bottom: 15 })
          .borderRadius(20)
          .backgroundColor('#FFFFFF');

          // 账号输入框：绑定account状态
          TextInput({ placeholder: '输入账号' ,text:this.account})
            .width('100%')
            .height(40)
            .backgroundColor('#FFFFFF')
            .borderRadius(8)
            .shadow({
              color: '#12000000',
              radius: 4,
              offsetX: 2,
              offsetY: 4
            })
            .margin({ bottom: 15 })
            .onChange((value: string) => this.account = value); // 输入时更新account

          // 密码输入框：绑定password状态
          TextInput({ placeholder: '输入密码' ,text:this.password})
            .type(InputType.Password)
            .width('100%')
            .height(40)
            .backgroundColor('#FFFFFF')
            .borderRadius(8)
            .shadow({
              color: '#12000000',
              radius: 4,
              offsetX: 2,
              offsetY: 4
            })
            .margin({ bottom: 15 })
            .onChange((value: string) => this.password = value); // 输入时更新password

          Text('忘记密码？')
            .fontSize(12)
            .fontColor('#FF0000')
            .margin({ bottom: 15 })
            .align(Alignment.Start)
            .width('100%');

          // 登录按钮：点击触发login方法
          Button('登录')
            .width('80%')
            .height(45)
            .backgroundColor('#ff77f0ec')
            .borderRadius(16)
            .onClick(() => this.request()); // 点击登录
          //.onClick(() => this.login()); // 点击登录
        }
        .width(257)
        .height(300)
        .transition(this.leftAnimations)
        .margin({ bottom: 20 });
      }
    }
  }

  build() {
    Stack() {
      Baoyanstartbg()
        .width('100%')
        .height('100%');

      Text('保研小助手')
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
        .width('80%')
        .height(50)
        .textAlign(TextAlign.Center)
        .margin({ bottom: 500 });

      this.LoginAnd2FA()
    }
    .width('100%')
    .height('100%');
  }
}
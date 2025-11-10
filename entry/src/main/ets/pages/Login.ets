import { Baoyanstartbg } from '../components/Baoyanstart';
import router from '@ohos.router'; // 导入路由模块
import { ROUTERstu, ROUTERsuper, ROUTERtea } from '../routerConstants'; // 导入路由常量
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';
import { StaticData, DynamicData } from '../constants';
import json from '@ohos.util.json';
import { BusinessError } from '@kit.BasicServicesKit';

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
  password: string
}

interface empty {}

@Entry
@Component
struct login {
  @State selectedValue: string = 'student'; // 初始选择学生身份
  @State account: string = ''; // 账号状态
  @State password: string = ''; // 密码状态
  CustomAnimate: AnimateParam = {
    duration: 250,
    curve: Curve.EaseInOut
  };

  async request() {
    if (this.account && this.password) {
      let httpRequest = http.createHttp();
      let user_type: number
      let RequestData: LoginRequest = {
        'user_type': this.selectedValue,
        'school_id': this.account,
        'password': this.password
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
            }
          }
        )
        let DataObj: Object | empty
        let DataObjTmp: object | null
        try {
          DataObjTmp = json.parse(Response.result.toString())
          DataObj = DataObjTmp ? DataObjTmp : {}
          if (Response.responseCode == 200 && DataObj && !(Object.keys(DataObj).includes('non_field_errors'))) {
            DynamicData.account_id = this.account
            DynamicData.token = (DataObj as Record<string, string>)['token']
            this.login()
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
            .animation(this.CustomAnimate);

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
        TextInput({ placeholder: '输入账号' })
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
        TextInput({ placeholder: '输入密码' })
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
      .margin({ bottom: 20 });
    }
    .width('100%')
    .height('100%');
  }
}
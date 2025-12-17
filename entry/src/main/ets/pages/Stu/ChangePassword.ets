import router from '@ohos.router'; // 导入路由模块
import { http } from '@kit.NetworkKit';
import json from '@ohos.util.json';
import { DynamicData, StaticData } from '../../constants';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

//import { CommonConstants } from '../common/constants';

interface data{
  oldpassword:string,
  newpassword:string
}
interface empty{}

@Entry
@Component
struct ChangePassword {
  // 密码输入状态管理
  @State oldPassword: string = '';
  @State newPassword: string = '';
  @State confirmPassword: string = '';
  // 错误提示信息
  @State errorMessage: string = '';

  // 返回图标资源
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");

  async Save():Promise<boolean>{
    let httpRequest = http.createHttp();
    let RequestData: data = {
      oldpassword:this.oldPassword,
      newpassword:this.newPassword
    }
    let RequestDataStr: string = json.stringify(RequestData)
    try {
      let Response: http.HttpResponse = await httpRequest.request(
        StaticData.ServerURL + '/api/account/user/change-password/',
        {
          method: http.RequestMethod.PUT,
          extraData: RequestDataStr,
          header: {
            'Content-Type': 'application/json', // 关键：添加这个头
            'Accept': 'application/json', // 可选：告诉服务器期望 JSON 响应
            'Authorization': 'Token '+DynamicData.token
          },
          connectTimeout:5000
        }
      )
      let DataObj: Object | empty
      let DataObjTmp: object | null
      try {
        DataObjTmp = json.parse(Response.result.toString())
        DataObj = DataObjTmp ? DataObjTmp : {}
        if (Response.responseCode == 200 && !(Object.keys(DataObj).includes('non_field_errors'))) {
          // 使用 promptAction 显示提示
          promptAction.showToast({
            message: '提交成功',
            duration: 2000 // 弹窗显示时间（毫秒）
          });
          return true
        } else {
          // 使用 promptAction 显示提示
          promptAction.showToast({
            message: '提交失败，请检查网络连接',
            duration: 2000 // 弹窗显示时间（毫秒）
          });
          return false
        }
      } catch (e) {
        let error = e as BusinessError
        let msg = error?.message
        // 使用 promptAction 显示提示
        promptAction.showToast({
          message: '解析错误：' + msg,
          duration: 2000 // 弹窗显示时间（毫秒）
        });
        return false;
      }
    } catch (e) {
      let err: BusinessError = e as BusinessError
      console.log(err.message)
      console.log(err.name)
      return false
    }
  }

  // 验证密码并提交
  async submitPasswordChange() {
    // 简单验证逻辑
    if (!this.oldPassword) {
      this.errorMessage = '请输入原密码';
      return;
    }

    if (this.newPassword.length < 6) {
      this.errorMessage = '新密码长度不能少于6位';
      return;
    }

    if (this.newPassword !== this.confirmPassword) {
      this.errorMessage = '两次输入的新密码不一致';
      return;
    }

    // 验证通过，这里可以添加实际修改密码的逻辑
    this.errorMessage = '';
    if(await this.Save()) {
      // 模拟修改成功后返回设置页
      setTimeout(() => {
        router.back()
      }, 500);
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        // 返回图标
        Image(this.image_back)
          .width(24)
          .height(24)
          .margin({ left: 8 })
          .onClick(() => {
            router.back()
          });

        // 页面标题
        Text('修改密码')
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .fontSize(14)
          .fontWeight(FontWeight.Medium);

        // 右侧占位元素，保持标题居中
        Column() {}
        .width(24)
        .height(24)
        .margin({ right: 8 });
      }
      .width('100%')
      .height(65)
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Center)
      .shadow({ radius: 2, color: '#00000010' });

      // 密码输入区域
      Column() {
        // 原密码输入框
        Column() {
          Text('原密码')
            .fontSize(14)
            .margin({ bottom: 5, left: 2 })
            .alignSelf(ItemAlign.Start);

          TextInput({ placeholder: '请输入原密码' })
            .type(InputType.Password) // 密码类型，输入内容会被隐藏
            .width('100%')
            .height(48)
            .backgroundColor('#ffffff')
            .borderRadius(8)
            .padding({ left: 12, right: 12 })
            .onChange((value: string) => {
              this.oldPassword = value;
            });
        }
        .margin({ bottom: 15 });

        // 新密码输入框
        Column() {
          Text('新密码')
            .fontSize(14)
            .margin({ bottom: 5, left: 2 })
            .alignSelf(ItemAlign.Start);

          TextInput({ placeholder: '请输入新密码（至少6位）' })
            .type(InputType.Password)
            .width('100%')
            .height(48)
            .backgroundColor('#ffffff')
            .borderRadius(8)
            .padding({ left: 12, right: 12 })
            .onChange((value: string) => {
              this.newPassword = value;
            });
        }
        .margin({ bottom: 15 });

        // 确认新密码输入框
        Column() {
          Text('确认新密码')
            .fontSize(14)
            .margin({ bottom: 5, left: 2 })
            .alignSelf(ItemAlign.Start);

          TextInput({ placeholder: '请再次输入新密码' })
            .type(InputType.Password)
            .width('100%')
            .height(48)
            .backgroundColor('#ffffff')
            .borderRadius(8)
            .padding({ left: 12, right: 12 })
            .onChange((value: string) => {
              this.confirmPassword = value;
            });
        }
        .margin({ bottom: 15 });

        // 错误提示
        if (this.errorMessage) {
          Text(this.errorMessage)
            .fontSize(14)
            .fontColor('#ff3b30') // 错误红色
            .margin({ bottom: 20 })
            .alignSelf(ItemAlign.Start);
        }

        // 提交按钮
        Button('确认修改')
          .width('100%')
          .height(48)
          .fontSize(16)
          .backgroundColor('#ff77f0ec') // 主题色
          .borderRadius(8)
          .onClick(() => this.submitPasswordChange())
          .margin({ top: 10 });

      }
      .width('90%')
      .padding({ top: 30 })
      .flexGrow(1);
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f4fafa');
  }
}

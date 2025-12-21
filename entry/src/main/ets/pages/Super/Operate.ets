import router from '@ohos.router';
import { http } from '@kit.NetworkKit';
import json from '@ohos.util.json';
import { DynamicData, StaticData } from '../../constants';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { CoolDownDialog } from '../../components/MainViews/Super/OperationComponents/CoolDownDialog';

interface data{
  accounts:string[]
}
interface empty{}

@Entry
@Component
struct OperationPage {
  @Prop image_back: ResourceStr = $r('app.media.LeftArrow');
  @Prop image_go: ResourceStr = $r("app.media.RightArrow");
  @State operationList: string[] = [
    '重置2FA',
    '删除账号',
    '导出数据',
    '重置密码',
  ];
  @State accounts:string[]=[]

  aboutToAppear(): void {
    this.accounts=(router.getParams() as data).accounts
  }

  async Request(path:string){
    let httpRequest = http.createHttp();
    let RequestData: data = {
      accounts:this.accounts
    }
    let RequestDataStr: string = json.stringify(RequestData)
    try {
      let Response: http.HttpResponse = await httpRequest.request(
        StaticData.ServerURL + path,
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

  build() {
    Column() {
      // 头部区域
      Row() {
        Image(this.image_back) // 假设存在返回图标资源
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .onClick(() => {
            router.back()
          });

        Text('操作')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .flexGrow(1)
          .textAlign(TextAlign.Center);
        Text('') // 占位，保持标题居中
          .width(24)
          .height(24)
          .margin({ right: 16 });
      }
      .width('100%')
      .height(56)
      .backgroundColor('#ffffff');

      // 操作列表区域
      Column() {
        List() {
          ForEach(this.operationList, (item: string, index: number) => {
            ListItem() {
              Row() {
                Text(item)
                  .fontSize(16)
                  .margin({ left: 16 });
                Image(this.image_go)
                  .width(20)
                  .height(20)
                  .margin({ right: 12 });
              }
              .width('100%')
              .height(48)
              .justifyContent(FlexAlign.SpaceBetween)
              .onClick(()=>{
                let CoolDownDialogInstance:CustomDialogController
                switch(index){
                  case 0:
                    CoolDownDialogInstance=new CustomDialogController({
                      builder: CoolDownDialog(
                        {
                          CoolDown:0,
                          title:'确认操作',
                          text:'确定要重置选定账号的2FA状态吗？这会要求用户重新导入2FA验证码。',
                          confirm: () => {
                            this.Request('')
                            CoolDownDialogInstance.close()
                          },
                          cancel:() => {
                            CoolDownDialogInstance.close()
                          }
                        }),
                      alignment: DialogAlignment.Center,
                      autoCancel: true
                    })
                    CoolDownDialogInstance.open()
                    break;
                  case 1:
                    CoolDownDialogInstance=new CustomDialogController({
                      builder: CoolDownDialog(
                        {
                          CoolDown:5,
                          title:'确认操作',
                          text:'确定要删除选定的账号吗？警告：该操作不可逆。',
                          confirm: () => {
                            this.Request('/api/account/admin/destroy/')
                            CoolDownDialogInstance.close()
                          },
                          cancel:() => {
                            CoolDownDialogInstance.close()
                          }
                        }),
                      alignment: DialogAlignment.Center,
                      autoCancel: true
                    })
                    CoolDownDialogInstance.open()
                    break;
                  case 2:
                    CoolDownDialogInstance=new CustomDialogController({
                      builder: CoolDownDialog(
                        {
                          CoolDown:0,
                          title:'确认操作',
                          text:'确定要导出选定账户的基本信息吗？',
                          confirm: () => {
                            this.Request('')
                            CoolDownDialogInstance.close()
                          },
                          cancel:() => {
                            CoolDownDialogInstance.close()
                          }
                        }),
                      alignment: DialogAlignment.Center,
                      autoCancel: true
                    })
                    CoolDownDialogInstance.open()
                    break;
                  case 3:
                    CoolDownDialogInstance=new CustomDialogController({
                      builder: CoolDownDialog(
                        {
                          CoolDown:0,
                          title:'确认操作',
                          text:'确定要重置选定账号的密码为123456吗？',
                          confirm: () => {
                            this.Request('/api/account/admin/reset_password/')
                            CoolDownDialogInstance.close()
                          },
                          cancel:() => {
                            CoolDownDialogInstance.close()
                          }
                        }),
                      alignment: DialogAlignment.Center,
                      autoCancel: true
                    })
                    CoolDownDialogInstance.open()
                    break;
                  default:
                    break;
                }
              })
            }
          });
        }
        .width('100%')
        .backgroundColor('#ffffff')
        .borderRadius(12)
        .margin({ left: 16, right: 16, top: 16, bottom: 24 });
      }
      .width('100%')
      .flexGrow(1);

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F8FA');
  }
}
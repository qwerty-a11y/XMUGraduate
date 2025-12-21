import router from '@ohos.router';
import { Account, Student, Teacher } from '../../datatypes/Account';
import { StudentDetail, TeacherDetail } from '../../datatypes/AccountDetail';
import { AccountList } from '../../service/Super/AccountList';
import { BusinessError, request } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import http from '@ohos.net.http';
import { DynamicData, StaticData } from '../../constants';
import { CoolDownDialog } from '../../components/MainViews/Super/OperationComponents/CoolDownDialog';
import json from '@ohos.util.json';
import { Environment, fileUri, picker } from '@kit.CoreFileKit';
import { DateUtils } from '../../utils';
import HttpFileManager from '../../service/HttpFileManager';
import { common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';

interface data{
  accounts:string[]
}
interface exportdata{
  filelink:string,
  filename:string
}
interface empty{}

@Entry
@Component
struct OperationPage {
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  @Prop image_back: ResourceStr = $r('app.media.LeftArrow');
  @Prop image_go: ResourceStr = $r("app.media.RightArrow");
  @State operationList: string[] = [
    '重置2FA',
    '删除账号',
    '导出数据',
    '重置密码',
  ];
  @State account?:Account=undefined
  @State isStudent:boolean = true
  @State Details:StudentDetail|TeacherDetail|undefined = undefined

  // 网络请求函数
  async getAccountDetail(
  type: boolean, // 0-学生，1-教师
  id: string
) {
  const httpRequest = http.createHttp();

  try {
    // 构建查询参数
    const params = `?type=${type ? 1 : 0}&id=${encodeURIComponent(id)}`;

    const response: http.HttpResponse = await httpRequest.request(
      `${StaticData.ServerURL}/api/account/admin/retrieve/${params}`, // 请替换为实际API路径
      {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': `Token ${DynamicData.token}`
        },
        connectTimeout: 5000
      }
    );

    if (response.responseCode === 200) {
      try {
        const responseData:StudentDetail|TeacherDetail = JSON.parse(response.result.toString()).data;
        if (!type) this.Details=responseData as StudentDetail
        if (type) this.Details=responseData as TeacherDetail
        this.account!.Name=this.Details!.name
      } catch (parseError) {
        const error = parseError as BusinessError;
        promptAction.showToast({
          message: `数据解析错误: ${error.message}`,
          duration: 2000
        });
      }
    } else {
      promptAction.showToast({
        message: `请求失败，状态码: ${response.responseCode}`,
        duration: 2000
      });
    }
  } catch (requestError) {
    const error = requestError as BusinessError;
    console.log(`请求错误: ${error.message}`);
    promptAction.showToast({
      message: '网络请求失败，请检查网络连接',
      duration: 2000
    });
  }
}

  async Request(path:string){
    let httpRequest = http.createHttp();
    let RequestData: data = {
      accounts:[this.account!.ID]
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

  async Export(){
    let downloaddata:exportdata
    //请求文件直链
    let httpRequest = http.createHttp();
    let RequestData: data = {
      accounts:[this.account!.ID]
    }
    let RequestDataStr: string = json.stringify(RequestData)
    try {
      let Response: http.HttpResponse = await httpRequest.request(
        StaticData.ServerURL + '/api/account/admin/export-users/',
        {
          method: http.RequestMethod.PUT,
          extraData: RequestDataStr,
          header: {
            'Content-Type': 'application/json', // 关键：添加这个头
            'Accept': 'application/json', // 可选：告诉服务器期望 JSON 响应
            'Authorization': 'Token '+DynamicData.token,
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
          downloaddata = (DataObj as exportdata)
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

    const downloadPath = Environment.getUserDownloadDir();
    const documentViewPicker = new picker.DocumentViewPicker(this.context);
    const documentSaveOptions = new picker.DocumentSaveOptions();
    documentSaveOptions.pickerMode = picker.DocumentPickerMode.DOWNLOAD;
    documentViewPicker.save(documentSaveOptions).then(async (documentSaveResult: Array<string>) => {
      let uri = documentSaveResult[0];
      const FilePath = new fileUri.FileUri(uri + '/' + downloaddata.filename).path;
      try {
        await fs.rename(this.context.cacheDir + '/' + downloaddata.filename, this.context.cacheDir + '/delete')
      } catch (e){
        console.error(`Failed to rename existed file. err: ${JSON.stringify(e)}`);
      }
      try {
        await fs.unlink(this.context.cacheDir + '/delete')
      } catch (e){
        console.error(`Failed to delete existed file. err: ${JSON.stringify(e)}`);
      }
      let file: request.DownloadTask | null = await HttpFileManager.download(this.context, {
        url: StaticData.ServerURL + downloaddata.filelink,
        header: { Authorization: "Token " + DynamicData.token },
        filePath: this.context.cacheDir + '/' + downloaddata.filename,
        //filePath: FilePath,
        onComplete: async () => {
          let srcFile = fs.openSync(this.context.cacheDir + '/' + downloaddata.filename)
          fs.copyFileSync(srcFile.fd,FilePath)
          promptAction.showToast({
            message: '文件已保存至Download/保研小助手/' + downloaddata.filename,
            duration: 2000
          })
        },
        onError: (e) => {
          let error = e as BusinessError
          let msg = error?.message
          // 使用 promptAction 显示提示
          promptAction.showToast({
            message: '下载失败：' + msg,
            duration: 2000 // 弹窗显示时间（毫秒）
          });
          return false
        }
      })
    })
    return true
  }

  aboutToAppear(): void {
    this.isStudent = (AccountList.Type < 2)
    if (this.isStudent) this.account = router.getParams() as Student
    else this.account = router.getParams() as Teacher
    this.getAccountDetail(!this.isStudent,this.account!.ID)
  }

  @Builder detail(){
    if (this.isStudent) {
      Column() {
        Column() {
          Text('基础信息')
            .fontSize(10)
            .width(300)
            .margin({ bottom: 5 })
          //------------------------为学生时-------------------------------
          Column() {
            Row() {
              Text('身份：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
              Text('学生')
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
            }
            //.margin({bottom:5})
            .width(320)
            .height(52)

            Row() {
              Divider()
                .width(230) // 可根据需要调整横线长度
                .color('#cccccc')
                .height(2)
            }
            .justifyContent(FlexAlign.End) // 使子组件（横线）靠右
            .width('80%') // Row宽度占满父容器
            //.margin({ bottom: 5 })

            Row() {
              Text('姓名：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text(this.Details?.name)
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
            }
            //.margin({bottom:5})
            .width(320)
            .height(52)

            Row() {
              Divider()
                .width(230) // 可根据需要调整横线长度
                .color('#cccccc')
                .height(2)
            }
            .justifyContent(FlexAlign.End) // 使子组件（横线）靠右
            .width('80%') // Row宽度占满父容器
            //.margin({ bottom: 5 })

            Row() {
              Text('单位：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text(this.Details?.department)
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
            }
            //.margin({bottom:5})
            .width(320)
            .height(52)


            Row() {
              Divider()
                .width(230) // 可根据需要调整横线长度
                .color('#cccccc')
                .height(2)
            }
            .justifyContent(FlexAlign.End) // 使子组件（横线）靠右
            .width('80%') // Row宽度占满父容器
            //.margin({ bottom: 5 })

            Row() {
              Text('账号：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text(this.account!.ID)
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
            }
            //.margin({bottom:5})
            .width(320)
            .height(52)

            Row() {
              Divider()
                .width(230) // 可根据需要调整横线长度
                .color('#cccccc')
                .height(2)
            }
            .justifyContent(FlexAlign.End) // 使子组件（横线）靠右
            .width('80%') // Row宽度占满父容器
            //.margin({ bottom: 5 })

            Row() {
              Text('手机号：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text(this.Details?.phone)
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
            }
            //.margin({bottom:5})
            .width(320)
            .height(52)


            Row() {
              Divider()
                .width(230) // 可根据需要调整横线长度
                .color('#cccccc')
                .height(2)
            }
            .justifyContent(FlexAlign.End) // 使子组件（横线）靠右
            .width('80%') // Row宽度占满父容器
            //.margin({ bottom: 5 })

            Row() {
              Text('邮箱：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text(this.Details?.email)
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
            }
            //.margin({bottom:5})
            .width(320)
            .height(52)

          }
          .width(320)
          .borderRadius(8)
          .backgroundColor('#ffff')
        }
      }
      .width('90%')
      .margin({ top: 10, bottom: 20 })

      Button() {
        Text('查看详细信息')
          .fontSize(16)
          .margin({ top: 10, bottom: 10 })
      }
      .backgroundColor('#77F0EC')
      .width('90%')
      .margin({ top: 10, bottom: 10 })
      .onClick(() => {
        router.pushUrl({ url: 'pages/Super/Individualinform' , params:{account:this.account,detail:this.Details}}, router.RouterMode.Single);
      })
    } else {
      Column() {
        Column() {
          Text('基础信息')
            .fontSize(10)
            .width(300)
            .margin({ bottom: 5 })
          Column() {
            Row() {
              Text('身份：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
              Text('教师')
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
            }
            //.margin({bottom:5})
            .width(320)
            .height(52)

            Row() {
              Divider()
                .width(230) // 可根据需要调整横线长度
                .color('#cccccc')
                .height(2)
            }
            .justifyContent(FlexAlign.End) // 使子组件（横线）靠右
            .width('80%') // Row宽度占满父容器
            //.margin({ bottom: 5 })

            Row() {
              Text('姓名：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text(this.Details?.name)
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
            }
            //.margin({bottom:5})
            .width(320)
            .height(52)

            Row() {
              Divider()
                .width(230) // 可根据需要调整横线长度
                .color('#cccccc')
                .height(2)
            }
            .justifyContent(FlexAlign.End) // 使子组件（横线）靠右
            .width('80%') // Row宽度占满父容器
            //.margin({ bottom: 5 })

            Row() {
              Text('单位：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text(this.Details?.department)
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
            }
            //.margin({bottom:5})
            .width(320)
            .height(52)


            Row() {
              Divider()
                .width(230) // 可根据需要调整横线长度
                .color('#cccccc')
                .height(2)
            }
            .justifyContent(FlexAlign.End) // 使子组件（横线）靠右
            .width('80%') // Row宽度占满父容器
            //.margin({ bottom: 5 })

            Row() {
              Text('账号：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text(this.account!.ID)
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
            }
            //.margin({bottom:5})
            .width(320)
            .height(52)

            Row() {
              Divider()
                .width(230) // 可根据需要调整横线长度
                .color('#cccccc')
                .height(2)
            }
            .justifyContent(FlexAlign.End) // 使子组件（横线）靠右
            .width('80%') // Row宽度占满父容器
            //.margin({ bottom: 5 })

            Row() {
              Text('手机号：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text(this.Details?.phone)
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
            }
            //.margin({bottom:5})
            .width(320)
            .height(52)


            Row() {
              Divider()
                .width(230) // 可根据需要调整横线长度
                .color('#cccccc')
                .height(2)
            }
            .justifyContent(FlexAlign.End) // 使子组件（横线）靠右
            .width('80%') // Row宽度占满父容器
            //.margin({ bottom: 5 })

            Row() {
              Text('邮箱：')
              //.flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })

              Text(this.Details?.email)
                .flexGrow(1)
                .fontSize(16)
                .margin({ top: 5, bottom: 5, left: 8 })
            }
            //.margin({bottom:5})
            .width(320)
            .height(52)

          }
          .width(320)
          .borderRadius(8)
          .backgroundColor('#ffff')
        }
      }
      .width('90%')
      .margin({ top: 10, bottom: 20 })

      Button(){
        Text('查看审核历史记录')
          .fontSize(16)
          .margin({top:10,bottom:10})
      }
      .backgroundColor('#77F0EC')
      .width('90%')
      .margin({top:10,bottom:10})
      .onClick(() => {
        router.pushUrl({ url: 'pages/Super/Teacheck',params:this.account }, router.RouterMode.Single);
      })
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

        Text('个人信息与操作')
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

      Scroll() {
        Column() {
          this.detail()
          // 操作列表区域
          Column() {
            Text('基础操作')
              .width('90%')
              .fontSize(10)
              .margin({bottom:-6})
            List() {
              ForEach(this.operationList, (item: string,index:number) => {
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
                                AccountList.List.splice(AccountList.List.indexOf(this.account as Account),1)
                                router.back()
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
                                this.Export()
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
            .margin({
              left: 16,
              right: 16,
              top: 16,
              bottom: 24
            });
          }
          .width('100%')
          .flexGrow(1);

        }
        .width('100%')
      }
      .width('100%')
      .flexGrow(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F8FA');
  }
}
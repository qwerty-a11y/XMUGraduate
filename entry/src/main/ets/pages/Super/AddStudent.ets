import router from '@ohos.router';
import { url } from '@kit.ArkTS';
import { FileSelectResult } from '../../datatypes/FilePicker';
import FilePickerManager from '../../service/FilePickerManager';
import HttpFileManager from '../../service/HttpFileManager';
import { common } from '@kit.AbilityKit';
import { FileItem } from '../../datatypes/File';
import { DynamicData, StaticData } from '../../constants';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct NewAddPage {
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  @Prop image_back: ResourceStr = $r('app.media.LeftArrow');
  @Prop image_download: ResourceStr = $r('app.media.Download');
  @Prop image_world: ResourceStr = $r('app.media.world');
  @State isTeacher: boolean = true; // 标记是教师还是学生，默认教师
  @State account: string = ''; // 账号
  @State majorClass: string = ''; // 专业班级
  @State dataExportPermission: boolean = false; // 数据导出权限状态
  @State progress:number = -1
  @State fileonupload:string = ''
  @State file?:FileSelectResult = undefined
  @Prop image_file: ResourceStr = $r("app.media.File");
  @Prop image_remove: ResourceStr = $r("app.media.Remove");

  async Upload(file:FileItem){
    HttpFileManager.upload(this.context,{
      url:StaticData.ServerURL+'/api/account/admin/import_users/',
      files:[file],
      header:{Authorization:"Token "+DynamicData.token},
      onProgress:(progress:number)=>{this.progress=progress},
    })
  }

  build() {
    Column() {
      // 头部区域
      Row() {
        Image(this.image_back)
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .onClick(() => {
            router.back()
          });

        Text('新添学生')
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

      // 表单区域
      Column() {
        Text('身份：学生')
          .width('96%')
          .fontSize(16)
          .margin({ top: 32,bottom:10 });

        Column(){
          Row(){
            Text('导入excel表格，格式见文档')
              .fontSize(14)
              .flexGrow(1)
            Column() {
              Image(this.image_world)
                .width(24)
            }
              .width(25)
          }
          .width('96%')
          .margin({bottom:10})

          if (this.progress<0) {
            Row() {
              Image(this.image_download)
                .height(52)
            }
            .onClick(async () => {
              this.file = await FilePickerManager.selectSingleDocument(this.context)
              if (this.file?.fileNames?.length) {
                this.progress = 0
                this.fileonupload = this.file!.fileNames![0]
              }
            })
            .justifyContent(FlexAlign.Center)
            .width('96%')
            .backgroundColor('#ffdedcdc')
            .borderRadius(20)
            .height(60)
          } else {
            Row({space:10}){
              Image(this.image_file).width('5%').margin({left:'5%',right:'5%'})
              Text(this.fileonupload).width('70%')
              Image(this.image_remove).width('5%').margin({left:'5%',right:'5%'})
                .onClick(()=>{
                  this.file=undefined
                  this.progress=-1
                })
            }.height(40)
          }

        }

        Text(`生成密码为：123456`)
          .fontSize(16)
          .width('96%')
          .margin({ top: 32 });

        Row() {
          Text('数据导出权限')
            .fontSize(16)
            .margin({ top: 16,bottom:10 });
          Toggle({ type: ToggleType.Switch, isOn: this.dataExportPermission })
            .margin({ top: 16, right: 16 })
            .onChange((isOn: boolean) => {
              this.dataExportPermission = isOn;
            });
        }
        .width('96%')

        Button('确定')
          .width(120)
          .height(40)
          .backgroundColor('#87E8DE')
          .borderRadius(20)
          .margin({ top: 24, bottom: 32 })
          .onClick(async () => {
            if (this.file?.fileNames?.[0]) {
              await this.Upload({
                filename: this.file!.fileNames![0],
                name: this.file!.fileNames![0],
                uri: this.file!.uris[0],
                type: 'application/octet-stream'
              })
              this.progress = -1
              router.back()
            }else {
              promptAction.showToast({
                message: '请选择文件',
                duration: 2000 // 弹窗显示时间（毫秒）
              });
            }
          });


      }
      .width('90%')
      .backgroundColor('#ffffff')
      .padding({left:10,right:10})
      .margin({ left: 16, right: 16,top:20 })
      .borderRadius(20)
      .shadow({
        radius: 4,
        color: '#ff5a5555',
        offsetX: 2,
        offsetY: 4
      });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F8FA');
  }
}
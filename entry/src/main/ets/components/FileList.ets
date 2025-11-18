import {HttpFileManager} from '../service/HttpFileManager'
import { common, Want } from '@kit.AbilityKit';
import {UploadOptions,DownloadOptions,HeadersObject,FormDataItem,FileItem,EmptyObject} from  '../datatypes/File'
import {FileSelectResult,PathInfo,DocumentSelectOptions,ImageSelectOptions} from '../datatypes/FilePicker'
import  {FilePickerManager} from '../service/FilePickerManager'
import { DynamicData, StaticData } from '../constants';
import { Attachment } from '../datatypes/Record';
import hash from '@ohos.file.hash';
import { request } from '@kit.BasicServicesKit';

@Component
export struct UploadFile{
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  @Link FileList:Attachment[]
  @Prop image_file: ResourceStr = $r("app.media.File");
  @Prop ReadOnly:boolean = true
  @Prop image_remove: ResourceStr = $r("app.media.Remove");
  @Prop image_add: ResourceStr = $r("app.media.Add");
  @State progress:number = -1
  @State fileonupload:string = ''

  async Upload(file:FileItem){
    HttpFileManager.upload(this.context,{
      url:StaticData.ServerURL+'/api/student/material/applications/fileupload',
      files:[file],
      header:{Authorization:"Token "+DynamicData.token},
      onProgress:(progress:number)=>{this.progress=progress},
    })
  }

  build() {
    Column(){
      ForEach(this.FileList,(item:Attachment,index:number)=>{
        Row({space:10}){
          Image(this.image_file).width('5%').margin({left:'5%',right:'5%'})
          Text(item.name).width('70%')
          Image(this.image_remove).width('5%').margin({left:'5%',right:'5%'})
            .onClick(()=>{
              this.FileList.splice(index,1)
            })
        }.height(40).onClick(async ()=>{
          let file:request.DownloadTask|null = await HttpFileManager.download(this.context,{
            url:"http://127.0.0.1:8000/api/student/material/applications/filedownload?id="+item.id,
            header:{Authorization:"Token "+DynamicData.token},
            filePath:this.context.cacheDir+item.name
          })
          if (file) {
            let want:Want={
              uri:this.context.cacheDir+item.name
            }
            this.context.startAbility(want)
          }
        })
      })
      if (this.progress>0){
        Stack(){
          Row(){
            Row().width(`${this.progress}%`).backgroundColor('#AAFFFF').borderRadius(0)
          }.height(40)
          Row({space:10}){
            Image(this.image_file).width('5%').margin({left:'5%',right:'5%'})
            Text(this.fileonupload).width('70%')
          }.height(40)
        }
      }
      Row() {
          Button() {
            Row() {
              Image(this.image_add).height(24)
              Text("上传文件")
            }
          }.height(40).padding({left:10,right:10}).backgroundColor("#0C182431").borderRadius(5).onClick(async ()=>{
            let file:FileSelectResult = await FilePickerManager.selectSingleDocument(this.context)
            if (file.fileNames?.length) {
              this.progress=0
              this.fileonupload=file.fileNames![0]
              await this.Upload({
                filename: file.fileNames![0],
                name: file.fileNames![0],
                uri: file.uris[0],
                type: 'application/octet-stream'
              })
              this.FileList.push({name:this.fileonupload,id:await hash.hash(file.uris[0],'sha256')})
              this.progress=-1
            }
          }).enabled(this.progress<0)
          Button() {
            Row() {
              Image(this.image_add).height(24)
              Text("上传图片")
            }
          }.height(40).padding({left:10,right:10}).backgroundColor("#0C182431").borderRadius(5).onClick(async ()=>{
            let file:FileSelectResult = await FilePickerManager.selectSingleImage(this.context)
            if (file.fileNames?.length) {
              this.progress=0
              this.fileonupload=file.fileNames![0]
              await this.Upload({
                filename: file.fileNames![0],
                name: file.fileNames![0],
                uri: file.uris[0],
                type: 'application/octet-stream'
              })
              this.FileList.push({name:this.fileonupload,id:await hash.hash(file.uris[0],'sha256')})
              this.progress=-1
            }
          }).enabled(this.progress<0)
        }.width('100%').justifyContent(FlexAlign.SpaceAround)
    }
  }
}
import {HttpFileManager} from '../service/HttpFileManager'
import { common, Want } from '@kit.AbilityKit';
import {UploadOptions,DownloadOptions,HeadersObject,FormDataItem,FileItem,EmptyObject} from  '../datatypes/File'
import {FileSelectResult,PathInfo,DocumentSelectOptions,ImageSelectOptions} from '../datatypes/FilePicker'
import  {FilePickerManager} from '../service/FilePickerManager'
import { DynamicData, StaticData } from '../constants';
import { filePreview } from '@kit.PreviewKit';
import { Attachment } from '../datatypes/Record';
import hash from '@ohos.file.hash';
import { request } from '@kit.BasicServicesKit';
import fileuri from '@ohos.file.fileuri';
//import { fileIo } from '@kit.CoreFileKit';
import fs from '@ohos.file.fs';
import { FileType } from '../utils';

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
  @State hash:string = ''

  Upload(file:FileItem){
    HttpFileManager.upload(this.context,{
      url:StaticData.ServerURL+'/api/student/material/applications/fileupload/',
      files:[file],
      header:{Authorization:"Token "+DynamicData.token},
      onProgress:(progress:number)=>{this.progress=progress},
      onComplete:()=>{
        this.FileList.push({ name: this.fileonupload, id: this.hash })
        this.progress = -1
      }
    })
  }

  build() {
    Column(){
      ForEach(this.FileList,(item:Attachment,index:number)=>{
        Row(){
          Image(this.image_file).width('5%').margin({left:'5%',right:'5%'})
          Text(item.name).width(this.ReadOnly?'85%':'70%')
          if (!this.ReadOnly) {
            Image(this.image_remove).width('5%').margin({ left: '5%', right: '5%' })
              .onClick(() => {
                this.FileList.splice(index, 1)
              })
          }
        }.height(40).backgroundColor('#eeeeee').onClick(async ()=>{
          try {
            await fs.rename('?id='+item.id, this.context.cacheDir + '/delete')
          } catch (e){
            console.error(`Failed to rename existed file. err: ${JSON.stringify(e)}`);
          }
          try {
            await fs.unlink(this.context.cacheDir + '/delete')
          } catch (e){
            console.error(`Failed to delete existed file. err: ${JSON.stringify(e)}`);
          }
          console.log(this.context.cacheDir+'/'+item.name+' - '+(await fs.access(this.context.cacheDir+'/'+item.name))?'True':'False')
          console.log(this.context.cacheDir+'/delete'+' - '+(await fs.access(this.context.cacheDir+'/delete'))?'True':'False')
          let file:request.DownloadTask|null = await HttpFileManager.download(this.context,{
            url:StaticData.ServerURL+"/api/student/material/applications/filedownload/?id="+item.id,
            header:{Authorization:"Token "+DynamicData.token},
            filePath:this.context.cacheDir+'/'+item.name,
            onComplete:async ()=>{
              //try {
                //fs.rename(this.context.cacheDir + '/?id='+item.id, this.context.cacheDir + '/'+item.name)
              //} catch (e){
                //console.error(`Failed to rename downloaded file. err: ${JSON.stringify(e)}`);
              //}
              let uri=fileuri.getUriFromPath(this.context.cacheDir+'/'+item.name)
              if (await filePreview.canPreview(this.context,uri)) {
                let preview: filePreview.PreviewInfo = {
                  uri: uri,
                  mimeType: FileType.getFileType(item.name)
                }
                filePreview.openPreview(this.context, preview)
              } else {
                let want:Want={
                  uri:uri
                }
                this.context.startAbility(want)
              }
            }
          })
        })
      })
      if (this.progress>=0){
        Stack(){
          Row(){
            Row().width(`${this.progress}%`).height(40).backgroundColor('#eeffff').borderRadius(0)
          }.justifyContent(FlexAlign.Start).height(40).width('100%')
          Row({space:10}){
            Image(this.image_file).width('5%').margin({left:'5%',right:'5%'})
            Text(this.fileonupload).width('70%')
          }.height(40).backgroundColor(Color.Transparent)
        }.width('100%')
      }
      if (!this.ReadOnly) {
        Row() {
          Button() {
            Row() {
              Image(this.image_add).height(24)
              Text("上传文件")
            }
          }
          .height(40)
          .padding({ left: 10, right: 10 })
          .backgroundColor("#0C182431")
          .borderRadius(5)
          .onClick(async () => {
            let file: FileSelectResult = await FilePickerManager.selectSingleDocument(this.context)
            if (file.fileNames?.length) {
              this.progress = 0
              this.fileonupload = file.fileNames![0]
              const srcFile = fs.openSync(file.uris![0], fs.OpenMode.READ_ONLY);
              const destPath=this.context.cacheDir+'/'+this.fileonupload
              this.hash = await hash.hash(srcFile.path, 'sha256')
              //let options:fileIo.CopyOptions = {}
              fs.copyFileSync(srcFile.fd,destPath)
              this.Upload({
                filename: file.fileNames![0],
                name: file.fileNames![0],
                uri: 'internal://cache/'+file.fileNames![0],
                type: 'application/octet-stream'
              })
            }
          })
          .enabled(this.progress < 0)

          Button() {
            Row() {
              Image(this.image_add).height(24)
              Text("上传图片")
            }
          }
          .height(40)
          .padding({ left: 10, right: 10 })
          .backgroundColor("#0C182431")
          .borderRadius(5)
          .onClick(async () => {
            let file: FileSelectResult = await FilePickerManager.selectSingleImage(this.context)
            if (file.fileNames?.length) {
              this.progress = 0
              this.fileonupload = file.fileNames![0]
              const srcFile = fs.openSync(file.uris![0], fs.OpenMode.READ_ONLY);
              const destPath=this.context.cacheDir+'/'+this.fileonupload
              //let options:fileIo.CopyOptions = {}
              fs.copyFileSync(srcFile.fd,destPath)
              this.hash = await hash.hash(destPath, 'sha256')
              this.Upload({
                filename: file.fileNames![0],
                name: file.fileNames![0],
                uri: 'internal://cache/'+file.fileNames![0],
                type: 'application/octet-stream'
              })
            }
          })
          .enabled(this.progress < 0)
        }.width('100%').justifyContent(FlexAlign.SpaceAround).margin({top:10})
      }
    }
  }
}

@Component
export struct UploadExcel{
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  @Link FileList:Attachment[]
  @Prop image_file: ResourceStr = $r("app.media.File");
  //@Prop ReadOnly:boolean = true
  @Prop image_remove: ResourceStr = $r("app.media.Remove");
  @Prop image_add: ResourceStr = $r("app.media.Add");
  @State progress:number = -1
  @State fileonupload:string = ''
  @State hash:string = ''

  Upload(file:FileItem){
    HttpFileManager.upload(this.context,{
      url:StaticData.ServerURL+'/api/account/admin/import_users/',
      files:[file],
      header:{Authorization:"Token "+DynamicData.token},
      onProgress:(progress:number)=>{this.progress=progress},
      onComplete:()=>{
        this.FileList.push({ name: this.fileonupload, id: this.hash })
        this.progress = -1
      }
    })
  }

  build() {
    Column(){
      ForEach(this.FileList,(item:Attachment,index:number)=>{
        Row(){
          Image(this.image_file).width('5%').margin({left:'5%',right:'5%'})
          Text(item.name).width('70%')
          Image(this.image_remove).width('5%').margin({ left: '5%', right: '5%' })
              .onClick(() => {
                this.FileList.splice(index, 1)
              })
        }.height(40).backgroundColor('#eeeeee')
      })
      if (this.progress>=0){
        Stack(){
          Row(){
            Row().width(`${this.progress}%`).height(40).backgroundColor('#eeffff').borderRadius(0)
          }.justifyContent(FlexAlign.Start).height(40).width('100%')
          Row({space:10}){
            Image(this.image_file).width('5%').margin({left:'5%',right:'5%'})
            Text(this.fileonupload).width('70%')
          }.height(40).backgroundColor(Color.Transparent)
        }.width('100%')
      }
      if (this.progress<0&&this.FileList.length==0) {
        Row() {
          Button() {
            Row() {
              Image(this.image_add).height(24)
              Text("上传文件")
            }
          }
          .height(40)
          .padding({ left: 10, right: 10 })
          .backgroundColor("#0C182431")
          .borderRadius(5)
          .onClick(async () => {
            let file: FileSelectResult = await FilePickerManager.selectSingleDocument(this.context)
            if (file.fileNames?.length) {
              this.progress = 0
              this.fileonupload = file.fileNames![0]
              const srcFile = fs.openSync(file.uris![0], fs.OpenMode.READ_ONLY);
              const destPath = this.context.cacheDir + '/' + this.fileonupload
              this.hash = await hash.hash(srcFile.path, 'sha256')
              //let options:fileIo.CopyOptions = {}
              fs.copyFileSync(srcFile.fd, destPath)
              this.Upload({
                filename: file.fileNames![0],
                name: file.fileNames![0],
                uri: 'internal://cache/' + file.fileNames![0],
                type: 'application/octet-stream'
              })
            }
          })
          .enabled(this.progress < 0)
        }.width('100%').justifyContent(FlexAlign.SpaceAround).margin({ top: 10 })
      }
    }
  }
}
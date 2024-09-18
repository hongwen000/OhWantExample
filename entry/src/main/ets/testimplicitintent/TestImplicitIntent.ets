import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import fileUri from '@ohos.file.fileuri';
import fs from '@ohos.file.fs';
import wantConstant from '@ohos.app.ability.wantConstant';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import createImageFile  from '../tools/ImageTool'

export default class TestImplicitIntent extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    this.createImageFileAndSendWant();
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/ImplicitIntentIndex', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  private createImageFileAndSendWant(): void {
    // 创建 img.jpg 文件用于测试
    const imgPath = createImageFile(this.context);

    // 将文件路径转换为文件 URI
    const imgUri = fileUri.getUriFromPath(imgPath);

    // 创建显式 Want 并设置目标组件
    const want: Want = {
      action: 'ohos.want.action.sendData',
      // 配置被分享文件的读写权限
      flags: wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION,
      // 配置分享应用的隐式拉起规则
      uri: imgUri,
      type: 'image/jpeg',
    };

    // 启动接收方组件
    this.context.startAbility(want).then(() => {
      console.info('启动接收方组件成功');
    }).catch((err: BusinessError) => {
      console.error(`启动接收方组件失败，错误码: ${err.code}, 错误信息: ${err.message}`);
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}

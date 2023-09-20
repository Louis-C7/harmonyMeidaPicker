import common from "@ohos.app.ability.common"

import { Options } from '../utils/Options'
@Component
struct launchCamera {
  @State options: Options = undefined;
  @State callback: void = {} = undefined;

  aboutToAppear() {
    let selectionLimit = this.options.selectionLimit;
    let isSingleSelect = selectionLimit === 1;
    let isPhoto = this.options.mediaType === 'photo'
    let isVideo = this.options.mediaType === "video"
  }

  startAbility(type, action) {
    let context = getContext(this) as common.UIAbilityContext
    let want = {
      "deviceId": "",
      "bundleName": "",
      "abilityName": "",
      "uri": "",
      "type": type,
      "action": action,
      "parameters": {},
      "entities": []
    };
    context.startAbility(want)
  }



  build(){}
}
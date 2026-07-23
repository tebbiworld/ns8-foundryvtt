<!--
  Copyright (C) 2026 tebbi
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <cv-grid fullWidth>
    <cv-row>
      <cv-column class="page-title"><h2>{{ $t("settings.title") }}</h2></cv-column>
    </cv-row>
    <cv-row v-if="error.getConfiguration">
      <cv-column>
        <NsInlineNotification kind="error" :title="$t('action.get-configuration')" :description="error.getConfiguration" :showCloseButton="false" />
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column>
        <cv-tile light>
          <cv-form @submit.prevent="configureModule">
            <!-- Publishing -->
            <cv-text-input
              :label="$t('settings.host')"
              v-model.trim="host"
              :placeholder="$t('settings.host_placeholder')"
              :helper-text="$t('settings.host_helper')"
              :disabled="loading.getConfiguration || loading.configureModule"
              :invalid-message="$t(error.host)"
              ref="host"
            ></cv-text-input>
            <cv-toggle value="lets_encrypt" :label="$t('settings.lets_encrypt')" v-model="lets_encrypt" :disabled="loading.getConfiguration || loading.configureModule" class="toggle">
              <template slot="text-left">{{ $t("settings.disabled") }}</template>
              <template slot="text-right">{{ $t("settings.enabled") }}</template>
            </cv-toggle>
            <cv-toggle value="http2https" :label="$t('settings.http2https')" v-model="http2https" :disabled="loading.getConfiguration || loading.configureModule" class="toggle">
              <template slot="text-left">{{ $t("settings.disabled") }}</template>
              <template slot="text-right">{{ $t("settings.enabled") }}</template>
            </cv-toggle>

            <!-- Foundry software download / activation -->
            <h4 class="section">{{ $t("settings.software_section") }}</h4>
            <cv-dropdown
              :label="$t('settings.auth_method')"
              v-model="auth_method"
              :helper-text="$t('settings.auth_method_helper')"
              :disabled="loading.getConfiguration || loading.configureModule"
              class="field"
            >
              <cv-dropdown-item value="credentials">{{ $t("settings.auth_credentials") }}</cv-dropdown-item>
              <cv-dropdown-item value="release_url">{{ $t("settings.auth_release_url") }}</cv-dropdown-item>
            </cv-dropdown>

            <template v-if="auth_method === 'credentials'">
              <cv-text-input
                :label="$t('settings.foundry_username')"
                v-model.trim="foundry_username"
                :helper-text="$t('settings.foundry_username_helper')"
                :disabled="loading.getConfiguration || loading.configureModule"
                :invalid-message="$t(error.foundry_username)"
                ref="foundry_username"
                class="field"
              ></cv-text-input>
              <cv-text-input
                type="password"
                :label="$t('settings.foundry_password')"
                v-model="foundry_password"
                :placeholder="foundry_password_set ? $t('settings.secret_keep_placeholder') : ''"
                :helper-text="secretHelper('foundry_password_set')"
                :password-hide-label="$t('settings.hide')"
                :password-show-label="$t('settings.show')"
                :disabled="loading.getConfiguration || loading.configureModule"
                :invalid-message="$t(error.foundry_password)"
                ref="foundry_password"
                class="field"
              ></cv-text-input>
            </template>

            <template v-else>
              <cv-text-input
                type="password"
                :label="$t('settings.release_url')"
                v-model.trim="release_url"
                :placeholder="release_url_set ? $t('settings.secret_keep_placeholder') : ''"
                :helper-text="secretHelper('release_url_set', 'settings.release_url_helper')"
                :password-hide-label="$t('settings.hide')"
                :password-show-label="$t('settings.show')"
                :disabled="loading.getConfiguration || loading.configureModule"
                :invalid-message="$t(error.release_url)"
                ref="release_url"
                class="field"
              ></cv-text-input>
            </template>

            <cv-text-input
              type="password"
              :label="$t('settings.license_key')"
              v-model.trim="license_key"
              :placeholder="license_key_set ? $t('settings.secret_keep_placeholder') : ''"
              :helper-text="secretHelper('license_key_set', 'settings.license_key_helper')"
              :password-hide-label="$t('settings.hide')"
              :password-show-label="$t('settings.show')"
              :disabled="loading.getConfiguration || loading.configureModule"
              class="field"
            ></cv-text-input>

            <!-- Instance options -->
            <h4 class="section">{{ $t("settings.instance_section") }}</h4>
            <cv-text-input
              type="password"
              :label="$t('settings.admin_key')"
              v-model="admin_key"
              :placeholder="admin_key_set ? $t('settings.secret_keep_placeholder') : ''"
              :helper-text="secretHelper('admin_key_set', 'settings.admin_key_helper')"
              :password-hide-label="$t('settings.hide')"
              :password-show-label="$t('settings.show')"
              :disabled="loading.getConfiguration || loading.configureModule"
              class="field"
            ></cv-text-input>
            <cv-text-input
              :label="$t('settings.foundry_version')"
              v-model.trim="foundry_version"
              :placeholder="$t('settings.foundry_version_placeholder')"
              :helper-text="$t('settings.foundry_version_helper')"
              :disabled="loading.getConfiguration || loading.configureModule"
              class="field"
            ></cv-text-input>
            <cv-text-input
              :label="$t('settings.timezone')"
              v-model.trim="timezone"
              :placeholder="$t('settings.timezone_placeholder')"
              :helper-text="$t('settings.timezone_helper')"
              :disabled="loading.getConfiguration || loading.configureModule"
              class="field"
            ></cv-text-input>

            <NsInlineNotification v-if="url" kind="info" :title="$t('settings.web_url')" :description="$t('settings.web_url_desc', { url })" :showCloseButton="false" class="info-tile" />
            <NsInlineNotification kind="info" :title="$t('settings.license_hint_title')" :description="$t('settings.license_hint_desc')" :showCloseButton="false" class="info-tile" />

            <cv-row v-if="error.configureModule">
              <cv-column>
                <NsInlineNotification kind="error" :title="$t('action.configure-module')" :description="error.configureModule" :showCloseButton="false" />
              </cv-column>
            </cv-row>
            <NsButton kind="primary" :icon="Save20" :loading="loading.configureModule" :disabled="loading.getConfiguration || loading.configureModule">{{ $t("settings.save") }}</NsButton>
          </cv-form>
        </cv-tile>
      </cv-column>
    </cv-row>
  </cv-grid>
</template>

<script>
import to from "await-to-js";
import { mapState } from "vuex";
import { QueryParamService, UtilService, TaskService, IconService, PageTitleService } from "@nethserver/ns8-ui-lib";

export default {
  name: "Settings",
  mixins: [TaskService, IconService, UtilService, QueryParamService, PageTitleService],
  pageTitle() {
    return this.$t("settings.title") + " - " + this.appName;
  },
  data() {
    return {
      q: { page: "settings" },
      urlCheckInterval: null,
      host: "",
      lets_encrypt: false,
      http2https: true,
      auth_method: "credentials",
      foundry_username: "",
      foundry_password: "",
      release_url: "",
      license_key: "",
      admin_key: "",
      foundry_version: "",
      timezone: "UTC",
      url: "",
      admin_key_set: false,
      foundry_password_set: false,
      release_url_set: false,
      license_key_set: false,
      loading: { getConfiguration: false, configureModule: false },
      error: { getConfiguration: "", configureModule: "", host: "", foundry_username: "", foundry_password: "", release_url: "" },
    };
  },
  computed: { ...mapState(["instanceName", "core", "appName"]) },
  beforeRouteEnter(to, from, next) {
    next((vm) => {
      vm.watchQueryData(vm);
      vm.urlCheckInterval = vm.initUrlBindingForApp(vm, vm.q.page);
    });
  },
  beforeRouteLeave(to, from, next) {
    clearInterval(this.urlCheckInterval);
    next();
  },
  created() {
    this.getConfiguration();
  },
  methods: {
    secretHelper(setFlag, baseKey) {
      const base = baseKey ? this.$t(baseKey) : "";
      if (this[setFlag]) {
        return (base ? base + " " : "") + this.$t("settings.secret_is_set");
      }
      return base;
    },
    async getConfiguration() {
      this.loading.getConfiguration = true;
      this.error.getConfiguration = "";
      const taskAction = "get-configuration";
      const eventId = this.getUuid();
      this.core.$root.$once(`${taskAction}-aborted-${eventId}`, this.getConfigurationAborted);
      this.core.$root.$once(`${taskAction}-completed-${eventId}`, this.getConfigurationCompleted);
      const res = await to(this.createModuleTaskForApp(this.instanceName, { action: taskAction, extra: { title: this.$t("action." + taskAction), isNotificationHidden: true, eventId } }));
      const err = res[0];
      if (err) {
        this.error.getConfiguration = this.getErrorMessage(err);
        this.loading.getConfiguration = false;
      }
    },
    getConfigurationAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getConfiguration = this.$t("error.generic_error");
      this.loading.getConfiguration = false;
    },
    getConfigurationCompleted(taskContext, taskResult) {
      this.loading.getConfiguration = false;
      const c = taskResult.output;
      this.host = c.host || "";
      this.lets_encrypt = !!c.lets_encrypt;
      this.http2https = c.http2https !== undefined ? !!c.http2https : true;
      this.auth_method = c.auth_method || "credentials";
      this.foundry_username = c.foundry_username || "";
      this.foundry_version = c.foundry_version || "";
      this.timezone = c.timezone || "UTC";
      this.url = c.url || "";
      this.admin_key_set = !!c.admin_key_set;
      this.foundry_password_set = !!c.foundry_password_set;
      this.release_url_set = !!c.release_url_set;
      this.license_key_set = !!c.license_key_set;
      // secrets are never echoed back — always start blank so a blank submit keeps them
      this.foundry_password = "";
      this.release_url = "";
      this.license_key = "";
      this.admin_key = "";
      this.focusElement("host");
    },
    validateConfigureModule() {
      this.clearErrors(this);
      let ok = true;
      const fail = (field, msg) => {
        this.error[field] = msg;
        if (ok) this.focusElement(field);
        ok = false;
      };
      if (!this.host) fail("host", "common.required");
      if (this.auth_method === "credentials") {
        if (!this.foundry_username) fail("foundry_username", "common.required");
        if (!this.foundry_password && !this.foundry_password_set) fail("foundry_password", "common.required");
      } else {
        if (!this.release_url && !this.release_url_set) fail("release_url", "common.required");
      }
      return ok;
    },
    configureModuleValidationFailed(validationErrors) {
      this.loading.configureModule = false;
      let focusSet = false;
      for (const e of validationErrors) {
        if (e.field !== "(root)") {
          this.error[e.field] = this.$t("settings." + e.error);
          if (!focusSet) {
            this.focusElement(e.field);
            focusSet = true;
          }
        }
      }
    },
    async configureModule() {
      if (!this.validateConfigureModule()) return;
      this.loading.configureModule = true;
      const taskAction = "configure-module";
      const eventId = this.getUuid();
      this.core.$root.$once(`${taskAction}-aborted-${eventId}`, this.configureModuleAborted);
      this.core.$root.$once(`${taskAction}-validation-failed-${eventId}`, this.configureModuleValidationFailed);
      this.core.$root.$once(`${taskAction}-completed-${eventId}`, this.configureModuleCompleted);
      const data = {
        host: this.host,
        lets_encrypt: this.lets_encrypt,
        http2https: this.http2https,
        auth_method: this.auth_method,
        admin_key: this.admin_key,
        license_key: this.license_key,
        foundry_version: this.foundry_version,
        timezone: this.timezone || "UTC",
      };
      if (this.auth_method === "credentials") {
        data.foundry_username = this.foundry_username;
        data.foundry_password = this.foundry_password;
      } else {
        data.release_url = this.release_url;
      }
      const res = await to(this.createModuleTaskForApp(this.instanceName, {
        action: taskAction,
        data,
        extra: { title: this.$t("settings.configure_instance", { instance: this.instanceName }), description: this.$t("common.processing"), eventId },
      }));
      const err = res[0];
      if (err) {
        this.error.configureModule = this.getErrorMessage(err);
        this.loading.configureModule = false;
      }
    },
    configureModuleAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.configureModule = this.$t("error.generic_error");
      this.loading.configureModule = false;
    },
    configureModuleCompleted() {
      this.loading.configureModule = false;
      this.getConfiguration();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
.field { margin-top: $spacing-06; }
.toggle { margin-top: $spacing-06; }
.info-tile { margin-top: $spacing-06; }
.section { margin-top: $spacing-07; margin-bottom: $spacing-03; }
</style>

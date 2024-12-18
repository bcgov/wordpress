import { defaultTheme } from "@vuepress/theme-default";
import { defineUserConfig } from "vuepress";
import { searchPlugin } from "@vuepress/plugin-search";
import { viteBundler } from "@vuepress/bundler-vite";

export default defineUserConfig({
  base: "/wordpress/",
  lang: "en-US",
  title: "WordPress Deployments",
  description: "Developer Documentation for WordPress Deployments",
  bundler: viteBundler({}),
  theme: defaultTheme({
    logo: "/images/BCID_H_rgb_pos.png",
    logoDark: "/images/BCID_H_rgb_rev.png",
    editLink: false,
    lastUpdated: false,
    repo: 'bcgov/wordpress',
    repoLabel: 'Github',
    navbar: [
      {
        text: 'Home',
        link: '/',
      },
    ],
    // sidebar array
    // all pages will use the same sidebar
    sidebar: [
      // SidebarItem
      {
        text: "Getting Started",
        collapsible: true,
        children: [
          "/guide/GettingStarted/deploy_locally",
          "/guide/GettingStarted/deploy_kubernetes",
          "/guide/GettingStarted/deploy_openshift",
        ]
      }, 
      // string - page file path
    ],
  }),
  plugins: [
    searchPlugin({
      // options
    })
  ],
  port: 30060

});

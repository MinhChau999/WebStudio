import type { AppContext } from "@webstudio-is/trpc-interface/index.server";
import env from "~/env/env.server";

export type UserPlanFeatures = NonNullable<AppContext["userPlanFeatures"]>;

export const getUserPlanFeatures = async (
  userId: string,
  postgrest: AppContext["postgrest"]
): Promise<UserPlanFeatures> => {
  const userProductsResult = await postgrest.client
    .from("UserProduct")
    .select("customerId, subscriptionId, productId")
    .eq("userId", userId);

  // If UserProduct table doesn't exist (PGRST205 = table not found), use env-based plan
  if (userProductsResult.error) {
    if (
      userProductsResult.error.code === "PGRST205" ||
      userProductsResult.error.code === "PGRST116"
    ) {
      // Table doesn't exist, use env-based plan
      console.log("UserProduct table not found, using default plan");

      // Return immediately with env-based plan
      if (env.USER_PLAN === "pro") {
        return {
          allowShareAdminLinks: true,
          allowDynamicData: true,
          maxContactEmails: 5,
          maxDomainsAllowedPerUser: Number.MAX_SAFE_INTEGER,
          maxPublishesAllowedPerUser: Number.MAX_SAFE_INTEGER,
          hasSubscription: true,
          hasProPlan: true,
          planName: "env.USER_PLAN Pro",
        };
      }

      return {
        allowShareAdminLinks: false,
        allowDynamicData: false,
        maxContactEmails: 0,
        maxDomainsAllowedPerUser: 0,
        maxPublishesAllowedPerUser: 10,
        hasSubscription: false,
        hasProPlan: false,
      };
    }

    // For other errors, log and throw to surface the issue
    console.error("Error fetching UserProduct:", userProductsResult.error);
    throw new Error(
      `Failed to fetch user products: ${userProductsResult.error.message}`
    );
  }

  const userProducts = userProductsResult.data ?? [];

  // No UserProduct records for this user, use env-based plan
  if (userProducts.length === 0) {
    if (env.USER_PLAN === "pro") {
      return {
        allowShareAdminLinks: true,
        allowDynamicData: true,
        maxContactEmails: 5,
        maxDomainsAllowedPerUser: Number.MAX_SAFE_INTEGER,
        maxPublishesAllowedPerUser: Number.MAX_SAFE_INTEGER,
        hasSubscription: true,
        hasProPlan: true,
        planName: "env.USER_PLAN Pro",
      };
    }

    return {
      allowShareAdminLinks: false,
      allowDynamicData: false,
      maxContactEmails: 0,
      maxDomainsAllowedPerUser: 0,
      maxPublishesAllowedPerUser: 10,
      hasSubscription: false,
      hasProPlan: false,
    };
  }

  const productsResult = await postgrest.client
    .from("Product")
    .select("name, meta")
    .in(
      "id",
      userProducts.map(({ productId }) => productId ?? "")
    );

  if (productsResult.error) {
    console.error(productsResult.error);
    // If Product table doesn't exist, return default pro plan for users with UserProduct records
    return {
      allowShareAdminLinks: true,
      allowDynamicData: true,
      maxContactEmails: 5,
      maxDomainsAllowedPerUser: Number.MAX_SAFE_INTEGER,
      maxPublishesAllowedPerUser: Number.MAX_SAFE_INTEGER,
      hasSubscription: userProducts.some((log) => log.subscriptionId !== null),
      hasProPlan: true,
      planName: "User",
    };
  }

  const products = productsResult.data;

  // UserProduct records exist and have valid Product data
  if (products.length > 0) {
    const hasSubscription = userProducts.some(
      (log) => log.subscriptionId !== null
    );
    const productMetas = products.map((product) => {
      return {
        allowShareAdminLinks: true,
        allowDynamicData: true,
        maxContactEmails: 5,
        maxDomainsAllowedPerUser: Number.MAX_SAFE_INTEGER,
        maxPublishesAllowedPerUser: Number.MAX_SAFE_INTEGER,
        ...(product.meta as Partial<UserPlanFeatures>),
      };
    });
    return {
      allowShareAdminLinks: productMetas.some(
        (item) => item.allowShareAdminLinks
      ),
      allowDynamicData: productMetas.some((item) => item.allowDynamicData),
      maxContactEmails: Math.max(
        ...productMetas.map((item) => item.maxContactEmails)
      ),
      maxDomainsAllowedPerUser: Math.max(
        ...productMetas.map((item) => item.maxDomainsAllowedPerUser)
      ),
      maxPublishesAllowedPerUser: Math.max(
        ...productMetas.map((item) => item.maxPublishesAllowedPerUser)
      ),
      hasSubscription,
      hasProPlan: true,
      planName: products[0].name,
    };
  }

  // Fallback for users with UserProduct but no Product records
  return {
    allowShareAdminLinks: true,
    allowDynamicData: true,
    maxContactEmails: 5,
    maxDomainsAllowedPerUser: Number.MAX_SAFE_INTEGER,
    maxPublishesAllowedPerUser: Number.MAX_SAFE_INTEGER,
    hasSubscription: userProducts.some((log) => log.subscriptionId !== null),
    hasProPlan: true,
    planName: "User",
  };
};

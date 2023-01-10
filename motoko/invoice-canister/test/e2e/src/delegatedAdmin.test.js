const identityUtils = require('./utils/identity');
const {
  delegatedAdminIdentity,
  delegatedAdministrator, 
  getRandomActor,
  anonymousPrincipal
} = identityUtils;

jest.setTimeout(30000);   

describe("test setting and getting the delegated administrator", () => {
  it("should not allow an unauthorized caller from setting the delegated admin", async () => {
    const result = await getRandomActor().set_delegated_administrator({ who: delegatedAdminIdentity.getPrincipal() });
    expect(result.err.kind).toStrictEqual({ NotAuthorized: null });
  });
  it("should not allow an unauthorized caller from getting the principal of the delegated admin", async () => {
    const result = await getRandomActor().get_delegated_administrator();
    expect(result.err.kind).toStrictEqual({ NotAuthorized: null });
  });
  it("should allow the delegated admin to set the delegated admin", async () => {
    const result = await delegatedAdministrator.set_delegated_administrator({ who: delegatedAdminIdentity.getPrincipal() });
    expect(result.ok).toStrictEqual({
      message: `Principal ${delegatedAdminIdentity.getPrincipal().toString()} set as the delegated administrator.`,
    });
  });
  it("should allow the delegated admin to get the principal of the delegated admin", async () => {
    const result = await delegatedAdministrator.get_delegated_administrator();
    expect(result.ok).toStrictEqual({
      delegatedAdmin: delegatedAdminIdentity.getPrincipal(),
    });
  });
  it("should not allow the delegated admin from setting the anonymous principal as the delegated admin", async () => {
    const result = await delegatedAdministrator.set_delegated_administrator({ who: anonymousPrincipal });
    expect(result.err).toStrictEqual({
      kind: {
          AnonymousIneligible: null,
      },
      message: ["The anonymous caller is not elgible to be the delegated administrator."],
    });
  });
});
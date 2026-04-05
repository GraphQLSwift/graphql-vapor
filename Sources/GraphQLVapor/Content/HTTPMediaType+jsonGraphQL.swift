import Vapor

extension HTTPMediaType {
    public static let jsonGraphQL = HTTPMediaType(
        type: "application",
        subType: "graphql-response+json",
        parameters: ["charset": "utf-8"]
    )
}

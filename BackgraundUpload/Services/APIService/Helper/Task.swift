enum Task {

    case requestPlain
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
}

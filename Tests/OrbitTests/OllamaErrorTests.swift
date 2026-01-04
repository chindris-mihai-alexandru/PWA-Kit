import XCTest
@testable import Orbit

/// Tests for OllamaError enum error descriptions
final class OllamaErrorTests: XCTestCase {
    
    // MARK: - Error Description Tests
    
    func testNotRunningErrorDescription() {
        let error = OllamaError.notRunning
        XCTAssertEqual(
            error.errorDescription,
            "Ollama is not running. Please start Ollama and try again."
        )
    }
    
    func testModelNotFoundErrorDescription() {
        let error = OllamaError.modelNotFound("llama3.2")
        XCTAssertEqual(
            error.errorDescription,
            "Model 'llama3.2' not found. Please pull the model first: ollama pull llama3.2"
        )
    }
    
    func testModelNotFoundWithDifferentModel() {
        let error = OllamaError.modelNotFound("codellama:7b")
        XCTAssertEqual(
            error.errorDescription,
            "Model 'codellama:7b' not found. Please pull the model first: ollama pull codellama:7b"
        )
    }
    
    func testStreamErrorDescription() {
        let error = OllamaError.streamError("Connection reset by peer")
        XCTAssertEqual(
            error.errorDescription,
            "Stream error: Connection reset by peer"
        )
    }
    
    func testStreamErrorWithEmptyMessage() {
        let error = OllamaError.streamError("")
        XCTAssertEqual(
            error.errorDescription,
            "Stream error: "
        )
    }
    
    func testInvalidResponseErrorDescription() {
        let error = OllamaError.invalidResponse
        XCTAssertEqual(
            error.errorDescription,
            "Received invalid response from Ollama"
        )
    }
    
    func testInvalidModelIDErrorDescription() {
        let error = OllamaError.invalidModelID("invalid model name")
        XCTAssertEqual(
            error.errorDescription,
            "Invalid model ID: 'invalid model name'"
        )
    }
    
    // MARK: - Error Protocol Conformance Tests
    
    func testOllamaErrorConformsToError() {
        let error: Error = OllamaError.notRunning
        XCTAssertNotNil(error)
    }
    
    func testOllamaErrorConformsToLocalizedError() {
        let error: LocalizedError = OllamaError.notRunning
        XCTAssertNotNil(error.errorDescription)
    }
    
    // MARK: - Error Cases Are Distinct
    
    func testAllErrorCasesHaveUniqueDescriptions() {
        let errors: [OllamaError] = [
            .notRunning,
            .modelNotFound("test"),
            .streamError("test"),
            .invalidResponse,
            .invalidModelID("test")
        ]
        
        let descriptions = errors.compactMap { $0.errorDescription }
        let uniqueDescriptions = Set(descriptions)
        
        XCTAssertEqual(descriptions.count, uniqueDescriptions.count, "All error descriptions should be unique")
    }
}
